BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER trg_przejazd_check_and_autofill';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -4080 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER trg_kierowca_email_normalize';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -4080 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP PROCEDURE dodaj_gokart_jesli_brak';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -4043 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP PROCEDURE korekta_czasow_przejazdow';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -4043 THEN RAISE; END IF;
END;
/

/*
PROCEDURA: dodaj_gokart_jesli_brak
Opis dzialania:
1) Przyjmuje w parametrze typ gokarta (p_typ).
2) Sprawdza, czy parametr jest pusty lub NULL:
   - jesli tak, konczy dzialanie i wypisuje komunikat.
3) Sprawdza w tabeli GOKART, czy istnieje juz rekord o takim samym typie (ignorujac wielkosc liter).
4) Jesli rekord istnieje:
   - nie wykonuje INSERT,
   - wypisuje komunikat, ze gokart nie zostal dodany.
5) Jesli rekord nie istnieje:
   - wyznacza nowe ID jako MAX(id_gokartu)+1,
   - wykonuje INSERT do tabeli GOKART,
   - wypisuje komunikat o dodaniu gokarta.
Operacje DML: INSERT (gdy gokart nie istnieje).
IF: walidacja parametru i rozgalezienie zalezne od istnienia rekordu.
*/
CREATE OR REPLACE PROCEDURE dodaj_gokart_jesli_brak(
    p_typ IN Gokart.typ%TYPE
) AS
    v_cnt NUMBER;
    v_new_id NUMBER;
BEGIN
    IF p_typ IS NULL OR LENGTH(TRIM(p_typ)) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nie dodano gokarta: pusty typ.');
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_cnt
    FROM Gokart
    WHERE LOWER(typ) = LOWER(TRIM(p_typ));

    IF v_cnt > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nie dodano gokarta: typ juz istnieje (' || TRIM(p_typ) || ').');
    ELSE
        SELECT NVL(MAX(id_gokartu), 0) + 1 INTO v_new_id FROM Gokart;

        INSERT INTO Gokart (id_gokartu, typ)
        VALUES (v_new_id, TRIM(p_typ));

        DBMS_OUTPUT.PUT_LINE('Dodano gokarta: ID=' || v_new_id || ', typ=' || TRIM(p_typ));
    END IF;
END;
/
SHOW ERRORS;

/*
PROCEDURA: korekta_czasow_przejazdow (KURSOR)
Opis dzialania:
1) Przyjmuje dwa progi: p_dolny_prog oraz p_gorny_prog.
2) Sprawdza poprawnosci progow:
   - oba musza byc nie-NULL,
   - p_dolny_prog musi byc mniejszy od p_gorny_prog,
   - w przeciwnym razie konczy dzialanie i wypisuje komunikat.
3) Definiuje kursor pobierajacy przejazdy indywidualne (gdzie Id_kierowcy IS NOT NULL).
4) Otwiera kursor i w petli FETCH pobiera kolejne przejazdy.
5) Dla kazdego przejazdu:
   - jesli czas < p_dolny_prog, zwieksza czas o 10% (UPDATE),
   - jesli czas > p_gorny_prog, zmniejsza czas o 10% (UPDATE),
   - po zmianie wypisuje komunikat ze starym i nowym czasem.
6) Zamyka kursor po przetworzeniu wszystkich rekordow.
Operacje DML: UPDATE na tabeli PRZEJAZD.
IF: sprawdzenie progow oraz decyzja o zwiekszeniu/zmniejszeniu czasu.
Kursor: jawny kursor c (OPEN/FETCH/CLOSE).
*/
CREATE OR REPLACE PROCEDURE korekta_czasow_przejazdow(
    p_dolny_prog IN Przejazd.Czas_przejazdu%TYPE,
    p_gorny_prog IN Przejazd.Czas_przejazdu%TYPE
) AS
    CURSOR c IS
        SELECT id_przejazdu, Czas_przejazdu
        FROM Przejazd
        WHERE Id_kierowcy IS NOT NULL;

    v_id   Przejazd.id_przejazdu%TYPE;
    v_czas Przejazd.Czas_przejazdu%TYPE;
    v_new  Przejazd.Czas_przejazdu%TYPE;
BEGIN
    IF p_dolny_prog IS NULL OR p_gorny_prog IS NULL OR p_dolny_prog >= p_gorny_prog THEN
        DBMS_OUTPUT.PUT_LINE('Nie wykonano: bledne progi (dolny < gorny).');
        RETURN;
    END IF;

    OPEN c;
    LOOP
        FETCH c INTO v_id, v_czas;
        EXIT WHEN c%NOTFOUND;

        IF v_czas < p_dolny_prog THEN
            v_new := ROUND(v_czas * 1.10, 3);
            UPDATE Przejazd
            SET Czas_przejazdu = v_new
            WHERE id_przejazdu = v_id;

            DBMS_OUTPUT.PUT_LINE('Zmieniono przejazd ' || v_id || ': ' || v_czas || ' -> ' || v_new);

        ELSIF v_czas > p_gorny_prog THEN
            v_new := ROUND(v_czas * 0.90, 3);
            UPDATE Przejazd
            SET Czas_przejazdu = v_new
            WHERE id_przejazdu = v_id;

            DBMS_OUTPUT.PUT_LINE('Zmieniono przejazd ' || v_id || ': ' || v_czas || ' -> ' || v_new);
        END IF;
    END LOOP;
    CLOSE c;
END;
/
SHOW ERRORS;

/*
TRIGGER: trg_przejazd_check_and_autofill (FOR EACH ROW)
Opis dzialania:
1) Uruchamia sie PRZED operacjami INSERT lub UPDATE na tabeli PRZEJAZD.
2) Dziala dla kazdego wiersza osobno (FOR EACH ROW).
3) Sprawdza warunki poprawnosci danych:
   - Czas_przejazdu musi byc > 0 (w przeciwnym razie RAISE_APPLICATION_ERROR),
   - musi byc podany dokladnie jeden identyfikator: Id_kierowcy ALBO id_druzyny:
     * jesli oba podane -> blad,
     * jesli oba NULL -> blad.
4) Jesli pole Data jest NULL, automatycznie ustawia je na SYSDATE (uzupelnienie danych).
Operacje DML: posrednio modyfikuje wartosc :NEW.Data (autofill) przed zapisem wiersza.
IF: walidacja czasu i poprawnej identyfikacji (kierowca/druzyna) + uzupelnienie daty.
*/
CREATE OR REPLACE TRIGGER trg_przejazd_check_and_autofill
BEFORE INSERT OR UPDATE ON Przejazd
FOR EACH ROW
BEGIN
    IF :NEW.Czas_przejazdu <= 0 THEN
        RAISE_APPLICATION_ERROR(-20101, 'Czas przejazdu musi byc > 0');
    END IF;

    IF :NEW.Id_kierowcy IS NOT NULL AND :NEW.id_druzyny IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20102, 'Podaj albo kierowce albo druzyne (nie oba).');
    END IF;

    IF :NEW.Id_kierowcy IS NULL AND :NEW.id_druzyny IS NULL THEN
        RAISE_APPLICATION_ERROR(-20103, 'Musi byc podany kierowca albo druzyna.');
    END IF;

    IF :NEW.Data IS NULL THEN
        :NEW.Data := SYSDATE;
    END IF;
END;
/
SHOW ERRORS;

/*
TRIGGER: trg_kierowca_email_normalize
Opis dzialania:
1) Uruchamia sie PRZED operacjami INSERT lub UPDATE na tabeli KIEROWCA.
2) Dziala dla kazdego wiersza osobno (FOR EACH ROW).
3) Normalizuje kolumne Email:
   - jesli Email jest NULL lub nie zawiera znaku '@', ustawia domyslny email 'brak_email@pjatk.pl',
   - w przeciwnym razie zamienia email na male litery (LOWER), aby ujednolicic zapis.
Operacje DML: modyfikuje wartosc :NEW.Email przed zapisem wiersza.
IF: sprawdza poprawnosc email i podejmuje decyzje o korekcie.
*/
CREATE OR REPLACE TRIGGER trg_kierowca_email_normalize
BEFORE INSERT OR UPDATE ON Kierowca
FOR EACH ROW
BEGIN
    IF :NEW.Email IS NULL OR INSTR(:NEW.Email, '@') = 0 THEN
        :NEW.Email := 'brak_email@pjatk.pl';
    ELSE
        :NEW.Email := LOWER(:NEW.Email);
    END IF;
END;
/
SHOW ERRORS;
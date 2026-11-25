-- Created by Redgate Data Modeler (https://datamodeler.redgate-platform.com)
-- Last modification date: 2025-12-19 08:28:32.952

-- tables
-- tables (safe drop)
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Szkolenie CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Przejazd CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Druzyna CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Instruktor CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Kierowca CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Gokart CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Tor CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Osoba CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/



-- Table: Druzyna
CREATE TABLE Druzyna (
    id_druzyny integer  NOT NULL,
    Id_kierowcy_1 integer  NOT NULL,
    Id_kierowcy_2 integer  NOT NULL,
    CONSTRAINT Druzyna_pk PRIMARY KEY (id_druzyny)
) ;

-- Table: Gokart
CREATE TABLE Gokart (
    id_gokartu integer  NOT NULL,
    typ varchar2(30)  NOT NULL,
    CONSTRAINT Gokart_pk PRIMARY KEY (id_gokartu)
) ;

-- Table: Instruktor
CREATE TABLE Instruktor (
    Id_instruktora integer  NOT NULL,
    Specjalizacja varchar2(40)  NOT NULL,
    CONSTRAINT Instruktor_pk PRIMARY KEY (Id_instruktora)
) ;

-- Table: Kierowca
CREATE TABLE Kierowca (
    Id_kierowcy integer  NOT NULL,
    Email varchar2(40)  NOT NULL,
    CONSTRAINT Kierowca_pk PRIMARY KEY (Id_kierowcy)
) ;

-- Table: Osoba
CREATE TABLE Osoba (
    Id_osoby integer  NOT NULL,
    Imie varchar2(30)  NOT NULL,
    Nazwisko varchar2(30)  NOT NULL,
    Numer_telefonu integer  NOT NULL,
    CONSTRAINT Osoba_pk PRIMARY KEY (Id_osoby)
) ;

-- Table: Przejazd
CREATE TABLE Przejazd (
    id_przejazdu integer  NOT NULL,
    id_gokartu integer  NOT NULL,
    id_toru integer  NOT NULL,
    Id_kierowcy integer  NULL,
    id_druzyny integer  NULL,
    Data date  NOT NULL,
    Czas_przejazdu number(5,3)  NOT NULL,
    CONSTRAINT Przejazd_pk PRIMARY KEY (id_przejazdu)
) ;

-- Table: Szkolenie
CREATE TABLE Szkolenie (
    Id_kierowcy integer  NOT NULL,
    Id_instruktora integer  NOT NULL,
    Data date  NOT NULL,
    CONSTRAINT Szkolenie_pk PRIMARY KEY (Id_kierowcy,Id_instruktora)
) ;

-- Table: Tor
CREATE TABLE Tor (
    id_toru integer  NOT NULL,
    Dlugosc number(3,0)  NOT NULL,
    CONSTRAINT Tor_pk PRIMARY KEY (id_toru)
) ;

-- foreign keys
-- Reference: Druzyna_Kierowca_1 (table: Druzyna)
ALTER TABLE Druzyna ADD CONSTRAINT Druzyna_Kierowca_1
    FOREIGN KEY (Id_kierowcy_1)
    REFERENCES Kierowca (Id_kierowcy);

-- Reference: Druzyna_Kierowca_2 (table: Druzyna)
ALTER TABLE Druzyna ADD CONSTRAINT Druzyna_Kierowca_2
    FOREIGN KEY (Id_kierowcy_2)
    REFERENCES Kierowca (Id_kierowcy);

-- Reference: Instruktor_Osoba (table: Instruktor)
ALTER TABLE Instruktor ADD CONSTRAINT Instruktor_Osoba
    FOREIGN KEY (Id_instruktora)
    REFERENCES Osoba (Id_osoby);

-- Reference: Kierowca_Osoba (table: Kierowca)
ALTER TABLE Kierowca ADD CONSTRAINT Kierowca_Osoba
    FOREIGN KEY (Id_kierowcy)
    REFERENCES Osoba (Id_osoby);

-- Reference: Przejazd_Druzyna (table: Przejazd)
ALTER TABLE Przejazd ADD CONSTRAINT Przejazd_Druzyna
    FOREIGN KEY (id_druzyny)
    REFERENCES Druzyna (id_druzyny);

-- Reference: Przejazd_Gokart (table: Przejazd)
ALTER TABLE Przejazd ADD CONSTRAINT Przejazd_Gokart
    FOREIGN KEY (id_gokartu)
    REFERENCES Gokart (id_gokartu);

-- Reference: Przejazd_Kierowca (table: Przejazd)
ALTER TABLE Przejazd ADD CONSTRAINT Przejazd_Kierowca
    FOREIGN KEY (Id_kierowcy)
    REFERENCES Kierowca (Id_kierowcy);

-- Reference: Przejazd_Tor (table: Przejazd)
ALTER TABLE Przejazd ADD CONSTRAINT Przejazd_Tor
    FOREIGN KEY (id_toru)
    REFERENCES Tor (id_toru);

-- Reference: Szkolenie_Instruktor (table: Szkolenie)
ALTER TABLE Szkolenie ADD CONSTRAINT Szkolenie_Instruktor
    FOREIGN KEY (Id_instruktora)
    REFERENCES Instruktor (Id_instruktora);

-- Reference: Szkolenie_Kierowca (table: Szkolenie)
ALTER TABLE Szkolenie ADD CONSTRAINT Szkolenie_Kierowca
    FOREIGN KEY (Id_kierowcy)
    REFERENCES Kierowca (Id_kierowcy);

-- End of file.




INSERT INTO Osoba VALUES (1, 'Kamil',    'Nowak',       500100101);
INSERT INTO Osoba VALUES (2, 'Ola',      'Kowalska',    500100102);
INSERT INTO Osoba VALUES (3, 'Marek',    'Wojcik',      500100103);
INSERT INTO Osoba VALUES (4, 'Julia',    'Zielinska',   500100104);
INSERT INTO Osoba VALUES (5, 'Piotr',    'Wisniewski',  500100105);
INSERT INTO Osoba VALUES (6, 'Anna',     'Mazur',       500200201);
INSERT INTO Osoba VALUES (7, 'Tomasz',   'Krawczyk',    500200202);
INSERT INTO Osoba VALUES (8, 'Karolina', 'Krol',        500200203);
INSERT INTO Osoba VALUES (9, 'Pawel',    'Wieczorek',   500200204);
INSERT INTO Osoba VALUES (10,'Magda',    'Sikora',      500200205);

INSERT INTO Kierowca VALUES (1, 'kamil.nowak@mail.com');
INSERT INTO Kierowca VALUES (2, 'ola.kowalska@mail.com');
INSERT INTO Kierowca VALUES (3, 'marek.wojcik@mail.com');
INSERT INTO Kierowca VALUES (4, 'julia.zielinska@mail.com');
INSERT INTO Kierowca VALUES (5, 'piotr.wisniewski@mail.com');

INSERT INTO Instruktor VALUES (6,  'Technika jazdy');
INSERT INTO Instruktor VALUES (7,  'Bezpieczenstwo');
INSERT INTO Instruktor VALUES (8,  'Zakrety');
INSERT INTO Instruktor VALUES (9,  'Start i hamowanie');
INSERT INTO Instruktor VALUES (10, 'Jazda w deszczu');

INSERT INTO Tor VALUES (1, 250);
INSERT INTO Tor VALUES (2, 320);
INSERT INTO Tor VALUES (3, 400);

INSERT INTO Gokart VALUES (1, 'Sodi RT8');
INSERT INTO Gokart VALUES (2, 'Sodi SR5');
INSERT INTO Gokart VALUES (3, 'Birel N35');
INSERT INTO Gokart VALUES (4, 'CRG Centurion');

INSERT INTO Druzyna VALUES (1, 1, 2);
INSERT INTO Druzyna VALUES (2, 3, 4);
INSERT INTO Druzyna VALUES (3, 2, 5);

INSERT INTO Szkolenie VALUES (1, 6, DATE '2025-10-01');
INSERT INTO Szkolenie VALUES (2, 7, DATE '2025-10-02');
INSERT INTO Szkolenie VALUES (3, 8, DATE '2025-10-03');
INSERT INTO Szkolenie VALUES (4, 9, DATE '2025-10-04');

INSERT INTO Przejazd VALUES (1, 1, 1, 1, NULL, DATE '2025-11-01', 58.321);
INSERT INTO Przejazd VALUES (2, 2, 1, 2, NULL, DATE '2025-11-01', 57.880);
INSERT INTO Przejazd VALUES (3, 3, 2, 3, NULL, DATE '2025-11-02', 71.450);
INSERT INTO Przejazd VALUES (4, 4, 2, 5, NULL, DATE '2025-11-02', 72.010);
INSERT INTO Przejazd VALUES (5, 1, 3, 1, NULL, DATE '2025-11-03', 88.333);
INSERT INTO Przejazd VALUES (6, 2, 3, 2, NULL, DATE '2025-11-03', 87.990);

INSERT INTO Przejazd VALUES (7, 3, 1, NULL, 1, DATE '2025-11-04', 58.777);
INSERT INTO Przejazd VALUES (8, 4, 1, NULL, 1, DATE '2025-11-04', 57.650);
INSERT INTO Przejazd VALUES (9, 1, 2, NULL, 2, DATE '2025-11-05', 70.900);
INSERT INTO Przejazd VALUES (10,2, 2, NULL, 3, DATE '2025-11-05', 71.005);

COMMIT;


-- 1) Zwraca kierowców, którzy nie mają żadnego szkolenia
SELECT k.Id_kierowcy, o.Imie, o.Nazwisko
FROM Kierowca k
JOIN Osoba o ON o.Id_osoby = k.Id_kierowcy
LEFT JOIN Szkolenie s ON s.Id_kierowcy = k.Id_kierowcy
WHERE s.Id_kierowcy IS NULL
ORDER BY k.Id_kierowcy;

-- 2) Zwraca instruktorów, którzy nie przeprowadzili żadnego szkolenia
SELECT i.Id_instruktora, o.Imie, o.Nazwisko, i.Specjalizacja
FROM Instruktor i
JOIN Osoba o ON o.Id_osoby = i.Id_instruktora
LEFT JOIN Szkolenie s ON s.Id_instruktora = i.Id_instruktora
WHERE s.Id_instruktora IS NULL
ORDER BY i.Id_instruktora;

-- 3) Zwraca kierowców, którzy nie mają żadnego przejazdu indywidualnego
SELECT k.Id_kierowcy, o.Imie, o.Nazwisko
FROM Kierowca k
JOIN Osoba o ON o.Id_osoby = k.Id_kierowcy
LEFT JOIN Przejazd p ON p.Id_kierowcy = k.Id_kierowcy
WHERE p.Id_kierowcy IS NULL
ORDER BY k.Id_kierowcy;

-- 4) Zwraca liczbę kierowców, którzy mają przynajmniej jeden przejazd indywidualny
SELECT COUNT(DISTINCT Id_kierowcy) AS ilu_kierowcow_ma_przejazd
FROM Przejazd
WHERE Id_kierowcy IS NOT NULL;

-- 5) Zwraca najlepszy czas na każdym torze
SELECT id_toru, MIN(Czas_przejazdu) AS rekord_toru
FROM Przejazd
GROUP BY id_toru
ORDER BY id_toru;

-- 6) Zwraca ranking kierowców według ich najlepszego czasu (z przejazdów indywidualnych)
SELECT p.Id_kierowcy, o.Imie, o.Nazwisko, MIN(p.Czas_przejazdu) AS najlepszy_czas
FROM Przejazd p
JOIN Osoba o ON o.Id_osoby = p.Id_kierowcy
WHERE p.Id_kierowcy IS NOT NULL
GROUP BY p.Id_kierowcy, o.Imie, o.Nazwisko
ORDER BY najlepszy_czas;

-- 7) Zwraca statystyki torów: długość toru, średni czas i liczbę przejazdów na torze
SELECT t.id_toru, t.Dlugosc,
       ROUND(AVG(p.Czas_przejazdu), 3) AS sredni_czas,
       COUNT(*) AS liczba_przejazdow
FROM Tor t
JOIN Przejazd p ON p.id_toru = t.id_toru
GROUP BY t.id_toru, t.Dlugosc
ORDER BY t.id_toru;

-- 8) Zwraca wykorzystanie gokartów: ile przejazdów wykonano danym gokartem i najlepszy czas na gokarcie
SELECT g.id_gokartu, g.typ,
       COUNT(*) AS ile_przejazdow,
       MIN(p.Czas_przejazdu) AS najlepszy_czas_na_gokarcie
FROM Gokart g
JOIN Przejazd p ON p.id_gokartu = g.id_gokartu
GROUP BY g.id_gokartu, g.typ
ORDER BY ile_przejazdow DESC;

-- 9) Zwraca skład (imiona/nazwiska) oraz najlepszy czas drużyny (z przejazdów drużynowych)
SELECT d.id_druzyny,
       o1.Imie AS imie_1, o1.Nazwisko AS nazwisko_1,
       o2.Imie AS imie_2, o2.Nazwisko AS nazwisko_2,
       MIN(p.Czas_przejazdu) AS najlepszy_czas_druzyny
FROM Druzyna d
JOIN Osoba o1 ON o1.Id_osoby = d.Id_kierowcy_1
JOIN Osoba o2 ON o2.Id_osoby = d.Id_kierowcy_2
JOIN Przejazd p ON p.id_druzyny = d.id_druzyny
GROUP BY d.id_druzyny, o1.Imie, o1.Nazwisko, o2.Imie, o2.Nazwisko
ORDER BY najlepszy_czas_druzyny;

-- 10) Zwraca przejazdy drużynowe wraz z informacją o torze (długość) i gokarcie (typ)
SELECT p.id_przejazdu, p.id_druzyny, p.Czas_przejazdu,
       t.id_toru, t.Dlugosc,
       g.typ
FROM Przejazd p
JOIN Tor t ON t.id_toru = p.id_toru
JOIN Gokart g ON g.id_gokartu = p.id_gokartu
WHERE p.id_druzyny IS NOT NULL
ORDER BY p.id_przejazdu;

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Maj 24, 2026 at 01:52 PM
-- Wersja serwera: 10.4.32-MariaDB
-- Wersja PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `szkola_sql`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `l2z02_uczniowie_klas_II_miasta_BR` ()   BEGIN
    SELECT 
        uczniowie.Nazwisko, 
        uczniowie.Imie, 
        uczniowie.IdU, 
        uczniowie.DUr, 
        uczniowie.Plec, 
        uczniowie.KlasaU, 
        miasta.NazwaM 
    FROM miasta 
    INNER JOIN uczniowie ON miasta.IdM = uczniowie.Miasto
    WHERE uczniowie.KlasaU LIKE 'II_' 
      AND miasta.NazwaM REGEXP '^[B-R]'
    ORDER BY uczniowie.Nazwisko, uczniowie.Imie;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `l2z05_nauczyciele_podany_staz` (IN `podany_staz` INT)   BEGIN
    SELECT 
        Nazwisko, 
        Imie, 
        DZatr, 
        TIMESTAMPDIFF(YEAR, DZatr, CURDATE()) AS Obliczony_Staz_Lata
    FROM nauczyciele
    WHERE TIMESTAMPDIFF(YEAR, DZatr, CURDATE()) < podany_staz
    ORDER BY Obliczony_Staz_Lata DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `l2z06_spis_nauczycieli_sortowanie` ()   BEGIN
    SELECT 
        Nazwisko, 
        Imie, 
        IdN, 
        DUr
    FROM nauczyciele
    ORDER BY 
        DUr DESC, 
        Nazwisko ASC, 
        Imie ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `l2z09_srednia_ocen_uczniow` ()   BEGIN
    SELECT 
        uczniowie.IdU AS Numer, 
        uczniowie.Nazwisko, 
        uczniowie.Imie, 
        ROUND(AVG(oceny.Ocena), 2) AS `Średnia ocen`
    FROM uczniowie 
    INNER JOIN oceny ON uczniowie.IdU = oceny.IdU
    GROUP BY 
        uczniowie.IdU, 
        uczniowie.Nazwisko, 
        uczniowie.Imie;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `l2z10_srednia_wszystkich_uczniow` ()   BEGIN
    SELECT 
        uczniowie.IdU AS Numer, 
        uczniowie.Nazwisko, 
        uczniowie.Imie, 
        IFNULL(ROUND(AVG(oceny.Ocena), 2), 0.00) AS `Średnia ocen`
    FROM uczniowie 
    LEFT JOIN oceny ON uczniowie.IdU = oceny.IdU
    GROUP BY 
        uczniowie.IdU, 
        uczniowie.Nazwisko, 
        uczniowie.Imie
    ORDER BY 
        uczniowie.Nazwisko ASC, 
        uczniowie.Imie ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `l2z14_uczniowie_w_miastach` ()   BEGIN
    SELECT 
        miasta.NazwaM, 
        COUNT(uczniowie.IdU) AS `Liczba uczniów`
    FROM miasta 
    LEFT JOIN uczniowie ON miasta.IdM = uczniowie.Miasto
    GROUP BY 
        miasta.NazwaM;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `l2z15_wychowawcy_klas` ()   BEGIN
    SELECT 
        klasy.Symbol, 
        nauczyciele.Nazwisko, 
        nauczyciele.Imie, 
        nauczyciele.IdN
    FROM nauczyciele 
    RIGHT JOIN klasy ON nauczyciele.IdN = klasy.Wych
    ORDER BY 
        klasy.Symbol ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `l2z16_godziny_nauczycieli` ()   BEGIN
    SELECT 
        nauczyciele.Nazwisko, 
        nauczyciele.Imie, 
        nauczyciele.IdN, 
        nauczyciele.Pensum, 
        IFNULL(SUM(uczy.IleGodz), 0) AS `Liczba godzin tygodniowo`
    FROM nauczyciele 
    LEFT JOIN uczy ON nauczyciele.IdN = uczy.IdN
    GROUP BY 
        nauczyciele.IdN, 
        nauczyciele.Nazwisko, 
        nauczyciele.Imie, 
        nauczyciele.Pensum
    ORDER BY 
        `Liczba godzin tygodniowo` DESC, 
        nauczyciele.Nazwisko ASC, 
        nauczyciele.Imie ASC, 
        nauczyciele.Pensum ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `l2z21_plec_w_klasach` ()   BEGIN
    SELECT 
        klasy.Symbol AS Klasa, 
        SUM(IF(uczniowie.Plec = 'K', 1, 0)) AS `Liczba dziewcząt`, 
        SUM(IF(uczniowie.Plec = 'M', 1, 0)) AS `Liczba chłopców`
    FROM klasy 
    LEFT JOIN uczniowie ON klasy.Symbol = uczniowie.KlasaU
    GROUP BY 
        klasy.Symbol;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `l2z28_uczniowie_takie_samo_imie` ()   BEGIN
    SELECT 
        CONCAT(u1.Nazwisko, ' ', u1.Imie, ' - ', u1.IdU) AS `Uczeń 1 - numer`, 
        CONCAT(u2.Nazwisko, ' ', u2.Imie, ' - ', u2.IdU) AS `Uczeń 2 - numer`
    FROM uczniowie AS u1
    INNER JOIN uczniowie AS u2 
        ON u1.Imie = u2.Imie AND u1.IdU < u2.IdU;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `klasy`
--

CREATE TABLE `klasy` (
  `Symbol` varchar(6) NOT NULL,
  `Profil` varchar(30) NOT NULL,
  `Wych` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `klasy`
--

INSERT INTO `klasy` (`Symbol`, `Profil`, `Wych`) VALUES
('Ia', 'matematyczno-informatyczny', NULL),
('Ib', 'biologiczno-chemiczny', 19),
('Ic', 'humanistyczny', 17),
('Id', 'jezykowy', 13),
('Ie', 'spoleczny', NULL),
('IIa', 'matematyczno-fizyczny', 4),
('IIb', 'ekonomiczny', 8),
('IIc', 'humanistyczny', 17),
('IId', 'informatyczny', NULL),
('IIIb', 'geograficzno-spoleczny', 15),
('IIIc', 'biologiczny', 7);

--
-- Wyzwalacze `klasy`
--
DELIMITER $$
CREATE TRIGGER `klasy_insert_check` BEFORE INSERT ON `klasy` FOR EACH ROW BEGIN
    IF NEW.Symbol = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Błąd: Pole Symbol nie może być puste!';
    END IF;
    IF NEW.Profil = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Błąd: Pole Profil nie może być puste!';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `klasy_update_check` BEFORE UPDATE ON `klasy` FOR EACH ROW BEGIN
    IF NEW.Symbol = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Błąd: Pole Symbol nie może być puste!';
    END IF;
    IF NEW.Profil = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Błąd: Pole Profil nie może być puste!';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `miasta`
--

CREATE TABLE `miasta` (
  `IdM` int(11) NOT NULL,
  `NazwaM` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `miasta`
--

INSERT INTO `miasta` (`IdM`, `NazwaM`) VALUES
(2, 'Białystok'),
(11, 'Boleslawiec'),
(13, 'Brzeg'),
(9, 'Brzeg Dolny'),
(7, 'Bydgoszcz'),
(3, 'Czestochowa'),
(12, 'Klodzko'),
(4, 'Poznan'),
(6, 'Radom'),
(5, 'Rzeszów'),
(10, 'Swidnica'),
(8, 'Walbrzych'),
(1, 'Wrocław');

--
-- Wyzwalacze `miasta`
--
DELIMITER $$
CREATE TRIGGER `no_empty_city_name` BEFORE UPDATE ON `miasta` FOR EACH ROW BEGIN
    IF NEW.NazwaM = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Błąd: Nazwa miasta nie może być pustym ciągiem znaków!';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `no_empty_city_name_insert` BEFORE INSERT ON `miasta` FOR EACH ROW BEGIN
    IF NEW.NazwaM = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Błąd: Nazwa miasta nie może być pustym ciągiem znaków!';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `nauczyciele`
--

CREATE TABLE `nauczyciele` (
  `IdN` int(11) NOT NULL,
  `Nazwisko` varchar(30) NOT NULL,
  `Imie` varchar(30) NOT NULL,
  `Plec` varchar(1) DEFAULT NULL,
  `DZatr` date DEFAULT NULL,
  `DUr` date DEFAULT NULL,
  `Pensja` float(10,2) DEFAULT 0.00,
  `Pensum` int(11) DEFAULT NULL,
  `Telefon` varchar(15) DEFAULT NULL,
  `Premia` float(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `nauczyciele`
--

INSERT INTO `nauczyciele` (`IdN`, `Nazwisko`, `Imie`, `Plec`, `DZatr`, `DUr`, `Pensja`, `Pensum`, `Telefon`, `Premia`) VALUES
(1, 'Kowalska', 'Anna', 'K', '2022-07-01', '1994-09-01', 4603.15, 90, '+48 575 338 136', 15.00),
(2, 'Nowak', 'Piotr', 'M', '2001-03-08', NULL, NULL, 30, NULL, NULL),
(3, 'Abacka', 'Ewa', NULL, NULL, '1993-09-01', 210.02, NULL, NULL, NULL),
(4, 'Abacka', 'Maria', 'K', NULL, '1999-04-18', NULL, 300, '573278999 dom', 132.00),
(5, 'Abacka', 'Maria', 'K', '2003-09-01', '1986-12-12', 66.00, 540, '+1 224 575 321', 3.00),
(6, 'Wójcik', 'Marek', 'M', '2008-08-29', NULL, 14.77, NULL, NULL, 5.00),
(7, 'Kaminska', 'Agnieszka', 'K', '2000-07-30', NULL, 2129.00, 270, '882 373 445', 1800.00),
(8, 'Lewandowski', 'Tomasz', NULL, NULL, '1979-11-29', 6699.00, 900, NULL, 21.00),
(9, 'Zielinska', 'Magdalena', 'K', '2019-09-03', '2000-01-01', 3218.00, NULL, '+48 626 574 374', 3.00),
(10, 'Szymanski', 'Krzysztof', 'M', '2020-05-29', '1998-07-23', 4455.00, 180, '432 701 329', 2.00),
(11, 'Szymanska', 'Monika', 'K', '2025-06-18', '1991-08-11', 13761.00, 90, '216783420 po 16', 89.00),
(12, 'Dabrowski', 'Andrzej', 'M', '0000-00-00', NULL, 1980.00, 330, NULL, 21.00),
(13, 'Kozlowska', 'Joanna', NULL, '2026-01-06', '2001-07-08', 3415.20, 420, NULL, 11.00),
(14, 'Jankowski', 'Pawel', 'M', '2003-04-05', '1987-10-10', 1782.00, 120, '500643189 po 9', 22.00),
(15, 'Mazur', 'Ewa', 'K', '2023-09-01', '1995-05-09', 1980.00, 600, '254 555 373', 1.00),
(16, 'Krawczyk', 'Michal', 'M', '2026-01-01', NULL, NULL, 120, '479135278 dom', 10.00),
(17, 'Piotrowska', 'Natalia', 'K', '2000-09-01', NULL, 2079.00, NULL, '389 000 234', 20500.00),
(18, 'Grabowski', 'Grzegorz', 'M', NULL, '1999-03-08', 6435.00, 900, NULL, NULL),
(19, 'Pawlak-Piasecka', 'Karolina', NULL, '2004-09-09', '1985-05-25', 3168.00, 30, '541 442 388', 11.00),
(20, 'Michalski', 'Lukasz', 'M', NULL, NULL, 1485.00, 270, NULL, 180.00),
(21, 'Kwiatkowska', 'Zofia', '', '2025-08-09', '1999-04-18', 300.00, NULL, '+48 262 555 321', 110.00);

--
-- Wyzwalacze `nauczyciele`
--
DELIMITER $$
CREATE TRIGGER `przed_aktualizacja_nauczyciela` BEFORE UPDATE ON `nauczyciele` FOR EACH ROW BEGIN
    IF TRIM(NEW.Nazwisko) = '' OR TRIM(NEW.Imie) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Błąd: Imię oraz Nazwisko nauczyciela nie mogą być puste ani składać się z samych spacji!';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `przed_wstawieniem_nauczyciela` BEFORE INSERT ON `nauczyciele` FOR EACH ROW BEGIN
    IF TRIM(NEW.Nazwisko) = '' OR TRIM(NEW.Imie) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Błąd: Imię oraz Nazwisko nauczyciela nie mogą być puste ani składać się z samych spacji!';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `oceny`
--

CREATE TABLE `oceny` (
  `IdU` int(11) NOT NULL,
  `IdP` int(11) NOT NULL,
  `Ocena` float(3,1) NOT NULL DEFAULT 0.0,
  `DataO` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `oceny`
--

INSERT INTO `oceny` (`IdU`, `IdP`, `Ocena`, `DataO`) VALUES
(6, 2, 4.5, '2026-03-16'),
(10, 1, 3.0, '2026-03-12'),
(10, 2, 2.0, NULL),
(10, 3, 5.0, '2026-03-16'),
(10, 4, 3.5, '2026-02-28'),
(10, 5, 3.0, NULL),
(10, 6, 5.0, '2026-03-16'),
(10, 7, 4.5, '2026-03-14'),
(10, 8, 4.0, '2026-03-11'),
(10, 9, 4.0, '2026-03-16'),
(10, 10, 5.0, '2026-02-20'),
(16, 4, 3.0, '2026-02-01'),
(21, 6, 3.5, NULL),
(22, 5, 2.0, '2026-02-05'),
(22, 9, 5.0, '2026-02-26'),
(24, 1, 3.5, '2026-02-11'),
(24, 3, 3.0, NULL),
(25, 4, 4.0, NULL),
(25, 9, 5.0, '2026-03-01'),
(31, 8, 4.5, '2026-03-16'),
(36, 6, 5.0, '2025-03-02'),
(36, 8, 3.0, '2026-03-11'),
(36, 10, 3.0, '2026-02-01'),
(40, 3, 2.0, '2026-03-08'),
(40, 6, 3.0, '2026-02-16'),
(40, 7, 3.0, '2025-02-20'),
(41, 9, 3.0, '2026-02-22'),
(41, 10, 3.0, '2026-02-28'),
(56, 5, 3.0, '2026-02-27'),
(56, 8, 3.0, '2026-03-26'),
(58, 4, 3.0, '2026-02-21'),
(59, 4, 3.0, '2025-02-01'),
(60, 9, 3.0, '2025-03-16'),
(60, 10, 3.0, '2026-03-06');

--
-- Wyzwalacze `oceny`
--
DELIMITER $$
CREATE TRIGGER `przed_aktualizacja_oceny` BEFORE UPDATE ON `oceny` FOR EACH ROW BEGIN
    IF NEW.Ocena < 1.0 OR NEW.Ocena > 5.0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Błąd: Ocena musi mieścić się w przedziale od 1.0 do 5.0!';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `przed_wstawieniem_oceny` BEFORE INSERT ON `oceny` FOR EACH ROW BEGIN
    IF NEW.Ocena < 1.0 OR NEW.Ocena > 5.0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Błąd: Ocena musi mieścić się w przedziale od 1.0 do 5.0!';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `przedmioty`
--

CREATE TABLE `przedmioty` (
  `IdP` int(11) NOT NULL,
  `NazwaP` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `przedmioty`
--

INSERT INTO `przedmioty` (`IdP`, `NazwaP`) VALUES
(1, 'Matematyka'),
(2, 'Chemia'),
(3, 'Biologia'),
(4, 'Informatyka'),
(5, 'Jezyk polski'),
(6, 'Geografia'),
(7, 'Historia'),
(8, 'Jezyk angielski'),
(9, 'Wiedza o spoleczenstwie'),
(10, 'Wychowanie fizyczne'),
(11, 'Jezyk Chinski');

--
-- Wyzwalacze `przedmioty`
--
DELIMITER $$
CREATE TRIGGER `przed_aktualizacja_nazwy_przedmiotu` BEFORE UPDATE ON `przedmioty` FOR EACH ROW BEGIN
    IF TRIM(NEW.NazwaP) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Błąd: Nazwa przedmiotu nie może być pusta ani składać się z samych spacji!';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `przed_wstawieniem_nazwy_przedmiotu` BEFORE INSERT ON `przedmioty` FOR EACH ROW BEGIN
    IF TRIM(NEW.NazwaP) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Błąd: Nazwa przedmiotu nie może być pusta ani składać się z samych spacji!';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uczniowie`
--

CREATE TABLE `uczniowie` (
  `IdU` int(11) NOT NULL,
  `Nazwisko` varchar(30) NOT NULL,
  `Imie` varchar(30) NOT NULL,
  `Plec` varchar(1) DEFAULT NULL,
  `KlasaU` varchar(6) DEFAULT NULL,
  `Miasto` int(11) DEFAULT NULL,
  `DUr` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `uczniowie`
--

INSERT INTO `uczniowie` (`IdU`, `Nazwisko`, `Imie`, `Plec`, `KlasaU`, `Miasto`, `DUr`) VALUES
(1, 'Kowalski', 'Adam', 'M', 'Ia', 6, '2007-03-12'),
(2, 'Kowalski', 'Adam', 'M', 'IIa', 6, '2007-06-21'),
(3, 'Kowalski', 'Michal', 'M', NULL, 7, '2007-01-18'),
(4, 'Nowak', 'Julia', NULL, 'Ia', 4, NULL),
(5, 'Wisniewski', 'Jakub', 'M', NULL, NULL, '2007-04-27'),
(6, 'Wójcik', 'Natalia', 'K', 'IIIb', 4, '2006-08-14'),
(7, 'Kaminski', 'Kacper', NULL, 'IIb', 6, '2007-02-19'),
(8, 'Lewandowska', 'Anna', 'K', NULL, 9, NULL),
(9, 'Zielinski', 'Pawel', 'M', 'Ic', NULL, '2007-11-12'),
(10, 'Szymanska', 'Martyna', NULL, 'Ie', 13, '2005-05-09'),
(11, 'Kozlowski', 'Filip', 'M', 'Id', 12, '2005-09-16'),
(12, 'Jankowska', 'Zuzanna', 'K', 'IIc', 10, NULL),
(13, 'Mazur', 'Mateusz', 'M', 'IIa', 6, '2005-01-22'),
(14, 'Krawczyk', 'Amelia', 'K', 'Ie', 4, NULL),
(15, 'Piotrowski', 'Bartosz', 'M', 'Id', 11, '2007-03-06'),
(16, 'Grabowska', 'Wiktoria', 'K', 'IIIb', 8, '2006-06-22'),
(17, 'Pawlak', 'Szymon', 'M', 'Ib', 5, '2007-04-12'),
(18, 'Michalska', 'Aleksandra', 'K', 'IIc', 1, NULL),
(19, 'Król', 'Patryk', 'M', 'Ia', 13, '2005-09-13'),
(20, 'Wieczorek', 'Karolina', 'K', 'Ie', 6, '2007-02-05'),
(21, 'Wróbel', 'Dominik', 'M', NULL, NULL, '2006-11-11'),
(22, 'Kaczmarek', 'Maja', 'K', 'IIb', 10, NULL),
(23, 'Piasecki', 'Tomasz', 'M', 'IIa', 1, '2007-10-22'),
(24, 'Adamska', 'Iga', NULL, 'IIa', 1, '2005-09-09'),
(25, 'Duda', 'Krzysztof', 'M', 'IId', 9, '2007-11-11'),
(26, 'Kubiak', 'Natalia', 'K', NULL, NULL, NULL),
(27, 'Baran', 'Lukasz', 'M', 'Ie', 8, '2007-02-14'),
(28, 'Lis', 'Julia', 'K', 'Ie', 5, '2005-03-03'),
(29, 'Sikora', 'Maciej', 'M', 'IIIb', 6, NULL),
(30, 'Tomczyk', 'Alicja', 'K', 'Id', 3, '2007-01-21'),
(31, 'Ostrowski', 'Adam', 'M', 'Ic', NULL, '2006-11-10'),
(32, 'Czarnecka', 'Magdalena', NULL, 'Ib', 13, '2005-01-22'),
(33, 'Malinowski', 'Sebastian', 'M', 'IIc', 7, '2006-03-21'),
(34, 'Górska', 'Paulina', 'K', 'Ia', NULL, '2007-08-12'),
(35, 'Urban', 'Adrian', 'M', NULL, 8, NULL),
(36, 'Kalinowska', 'Patrycja', 'K', 'IId', 9, NULL),
(37, 'Sawicki', 'Igor', 'M', 'IIIb', 12, '2008-02-17'),
(38, 'Marciniak', 'Kinga', 'K', 'Ie', NULL, '2008-08-18'),
(39, 'Rutkowski', 'Konrad', 'M', 'Id', 13, '2006-01-29'),
(40, 'Borkowska', 'Milena', 'K', 'Ia', 11, '2007-06-14'),
(41, 'Kania', 'Daniel', 'M', 'Ie', 11, '2004-12-12'),
(42, 'Sokolowska', 'Dominika', NULL, 'IIc', 10, '2007-03-19'),
(43, 'Maciejewski', 'Karol', 'M', 'Ia', 12, '2004-07-07'),
(44, 'Pietrzak', 'Ewa', 'K', NULL, 4, '2006-11-23'),
(45, 'Walczak', 'Rafal', 'M', 'IIIb', 8, NULL),
(46, 'Walczak', 'Gabriela', 'K', 'IIb', 6, '2008-08-27'),
(47, 'Stepien', 'Norbert', 'M', NULL, 3, '2006-12-31'),
(48, 'Kurek', 'Sandra', 'K', NULL, NULL, NULL),
(49, 'Kolodziej', 'Marcin', 'M', 'IIa', 13, '2006-02-06'),
(50, 'Borowska', 'Lena', 'K', 'Ia', 11, '2006-09-20'),
(51, 'Szczepanski', 'Marcin', 'M', 'Ie', 10, '2007-05-14'),
(52, 'Musial', 'Emilia', 'K', 'IIIb', 7, '2005-02-12'),
(53, 'Gajda', 'Oskar', 'M', NULL, NULL, '2007-03-25'),
(54, 'Pawlowska', 'Laura', 'K', 'Id', 1, '2006-06-18'),
(55, 'Wilk', 'Nikodem', 'M', 'Ib', 1, NULL),
(56, 'Jagiello', 'Hanna', 'K', NULL, 3, '2006-11-29'),
(57, 'Klos', 'Artur', 'M', 'Ia', 13, '2007-02-08'),
(58, 'Blaszczyk', 'Iga', 'K', NULL, 6, '2006-07-21'),
(59, 'Zawadzki', 'Tymon', 'M', 'IIc', 10, '2006-04-11'),
(60, 'Chmielewska', 'Nina', 'K', 'IIa', 9, '2008-09-05'),
(61, 'Awdziej', 'Maria', 'K', 'IIIb', 1, '2006-06-22'),
(62, 'Piotrowska', 'Zofia', 'K', 'Ia', 6, '2011-11-11');

--
-- Wyzwalacze `uczniowie`
--
DELIMITER $$
CREATE TRIGGER `przed_aktualizacja_ucznia` BEFORE UPDATE ON `uczniowie` FOR EACH ROW BEGIN
    IF TRIM(NEW.Nazwisko) = '' OR TRIM(NEW.Imie) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Błąd: Imię oraz Nazwisko ucznia nie mogą być puste ani składać się z samych spacji!';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `przed_wstawieniem_ucznia` BEFORE INSERT ON `uczniowie` FOR EACH ROW BEGIN
    IF TRIM(NEW.Nazwisko) = '' OR TRIM(NEW.Imie) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Błąd: Imię oraz Nazwisko ucznia nie mogą być puste ani składać się z samych spacji!';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uczy`
--

CREATE TABLE `uczy` (
  `IdN` int(11) NOT NULL,
  `IdP` int(11) NOT NULL,
  `IleGodz` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `uczy`
--

INSERT INTO `uczy` (`IdN`, `IdP`, `IleGodz`) VALUES
(3, 1, 20),
(3, 2, 2),
(3, 3, 1),
(3, 4, 1),
(3, 5, 8),
(3, 6, 3),
(3, 7, 2),
(3, 8, 2),
(3, 9, 4),
(3, 10, 4),
(6, 10, 30),
(7, 1, 12),
(7, 4, 18),
(8, 4, 30),
(9, 7, 10),
(9, 8, 10),
(9, 9, 10),
(11, 6, 5),
(13, 5, 1),
(13, 9, 0),
(14, 6, 12),
(15, 1, 15),
(15, 4, 15),
(16, 3, 10),
(17, 2, 10),
(17, 3, 20),
(17, 10, 20),
(19, 5, 7),
(19, 8, 5),
(19, 9, 18),
(20, 1, 21),
(20, 4, 9);

--
-- Wyzwalacze `uczy`
--
DELIMITER $$
CREATE TRIGGER `przed_aktualizacja_godzin` BEFORE UPDATE ON `uczy` FOR EACH ROW BEGIN
    IF NEW.IleGodz < 1 OR NEW.IleGodz > 40 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Błąd: Liczba godzin tygodniowo musi mieścić się w przedziale [1;40]!';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `przed_wstawieniem_godzin` BEFORE INSERT ON `uczy` FOR EACH ROW BEGIN
    IF NEW.IleGodz < 1 OR NEW.IleGodz > 40 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Błąd: Liczba godzin tygodniowo musi mieścić się w przedziale [1;40]!';
    END IF;
END
$$
DELIMITER ;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `klasy`
--
ALTER TABLE `klasy`
  ADD PRIMARY KEY (`Symbol`);

--
-- Indeksy dla tabeli `miasta`
--
ALTER TABLE `miasta`
  ADD PRIMARY KEY (`IdM`),
  ADD UNIQUE KEY `NazwaM` (`NazwaM`);

--
-- Indeksy dla tabeli `nauczyciele`
--
ALTER TABLE `nauczyciele`
  ADD PRIMARY KEY (`IdN`);

--
-- Indeksy dla tabeli `oceny`
--
ALTER TABLE `oceny`
  ADD PRIMARY KEY (`IdU`,`IdP`);

--
-- Indeksy dla tabeli `przedmioty`
--
ALTER TABLE `przedmioty`
  ADD PRIMARY KEY (`IdP`,`NazwaP`);

--
-- Indeksy dla tabeli `uczniowie`
--
ALTER TABLE `uczniowie`
  ADD PRIMARY KEY (`IdU`),
  ADD KEY `Miasto` (`Miasto`),
  ADD KEY `KlasaU` (`KlasaU`);

--
-- Indeksy dla tabeli `uczy`
--
ALTER TABLE `uczy`
  ADD PRIMARY KEY (`IdN`,`IdP`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `miasta`
--
ALTER TABLE `miasta`
  MODIFY `IdM` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `nauczyciele`
--
ALTER TABLE `nauczyciele`
  MODIFY `IdN` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `oceny`
--
ALTER TABLE `oceny`
  ADD CONSTRAINT `fk_oceny_przedmioty` FOREIGN KEY (`IdP`) REFERENCES `przedmioty` (`IdP`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_oceny_uczniowie` FOREIGN KEY (`IdU`) REFERENCES `uczniowie` (`IdU`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `uczniowie`
--
ALTER TABLE `uczniowie`
  ADD CONSTRAINT `fk_uczniowie_miasta_nowe` FOREIGN KEY (`Miasto`) REFERENCES `miasta` (`IdM`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `uczy`
--
ALTER TABLE `uczy`
  ADD CONSTRAINT `fk_uczy_nauczyciele` FOREIGN KEY (`IdN`) REFERENCES `nauczyciele` (`IdN`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_uczy_przedmioty` FOREIGN KEY (`IdP`) REFERENCES `przedmioty` (`IdP`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

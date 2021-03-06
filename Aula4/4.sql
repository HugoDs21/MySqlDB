-- 1.1

1. SELECT Nome, YEAR(DataNasc) FROM UTENTE;
2. SELECT Nome, MONTH(DataNasc), DAY(DataNasc) WHERE YEAR(DataNasc) > 2000;
3. SELECT Nome FROM UTENTE WHERE Nome LIKE 'Pedro%' OR Nome LIKE '%Silva';
4.
SELECT ISBN, Num, EmpUtente FROM CÓPIA
WHERE EmpUtente IS NOT NULL AND EmpUtente <> 1;

5. SELECT CONCAT (Título,', ',Editora,', ',Ano,', ',ISBN) FROM LIVRO;


-- 1.2

1. UPDATE UTENTE SET Email = UPPER(Email) WHERE Email IS NOT NULL;
2.
UPDATE CÓPIA SET Estante = 'E99', Prateleira = Prateleira + 1
WHERE Estante LIKE 'E1%';

-- 2.1

1. Email VARCHAR(32) DEFAULT NULL
2. Secção VARCHAR(3) NOT NULL DEFAULT 'L'
3. EmpUtente INT DEFAULT NULL
   EmpData DATE DEFAULT NULL

-- 2.2
CREATE TABLE UTENTE (
Num INT NOT NULL AUTO_INCREMENT ...

-- 2.3

1. ALTER TABLE LIVRO DROP Editora;
2.
ALTER TABLE LIVRO
ADD Conservação ENUM('Novo','Bom','Mau') NOT NULL DEFAULT 'Bom';

 


-- 2.4

FOREIGN KEY(ISBN) REFERENCES LIVRO(ISBN) ON UPDATE CASCADE


-- 3.0

1. SELECT Nome FROM AUTORES ORDER BY Nome;
2. SELECT DISTINCT Nome FROM AUTORES ORDER BY Nome;
3. SELECT Nome FROM UTENTE WHERE Sexo = 'M' ORDER BY DataNasc DESC;
4. SELECT Nome FROM UTENTE WHERE Sexo = 'F' ORDER BY DataNasc DESC LIMIT 1;
5. SELECT ISBN FROM CÓPIA WHERE EmpUtente IS NOT NULL ORDER BY ISBN, EmpUtente;
6. SELECT DISTINCT ISBN FROM CÓPIA WHERE EmpUtente IS NOT NULL;
7. SELECT ISBN FROM CÓPIA WHERE EmpUtente IS NOT NULL ORDER BY EmpData DESC LIMIT 3;

-- 4.0

1. SELECT COUNT(ISBN) FROM CÓPIA;
2. SELECT COUNT(ISBN) FROM CÓPIA WHERE EmpUtente IS NOT NULL;
3. SELECT COUNT(ISBN) FROM CÓPIA WHERE EmpUtente IS NOT NULL GROUP BY ISBN;
4.
SELECT COUNT(ISBN) FROM CÓPIA
WHERE EmpUtente IS NOT NULL
GROUP BY ISBN
HAVING COUNT(ISBN) >= 2;

5.
SELECT MAX(EmpData) FROM CÓPIA WHERE EmpUtente IS NOT NULL
GROUP BY ISBN ORDER BY MAX(EmpData);

6, 7 (?)


-- 5.0

1. SELECT U.Nome, C.ISBN, C.EmpData FROM UTENTE U, CÓPIA C ORDER BY U.Nome;

2.
SELECT U.Nome, L.Título, C.EmpData FROM UTENTE U, CÓPIA C, LIVRO L
WHERE C.ISBN = L.ISBN ORDER BY U.Nome, L.Título;

3.
SELECT L.Título, MAX(C.Num), COUNT(C.EmpUtente), MAX(C.Num)-COUNT(C.EmpUtente)
FROM LIVRO L, CÓPIA C WHERE L.ISBN = C.ISBN GROUP BY L.Título
ORDER BY MAX(C.Num), L.Título;


-- 6.0

1.
SELECT Título FROM LIVRO
WHERE ISBN IN ( SELECT ISBN FROM CÓPIA WHERE EmpUtente IS NOT NULL );

2.
SELECT Num, Nome FROM UTENTE WHERE
1 = ( SELECT COUNT(EmpUtente) FROM CÓPIA WHERE EmpUtente IS NOT NULL );

3.
SELECT Num, Nome FROM UTENTE WHERE
1 < ( SELECT COUNT(ISBN) FROM CÓPIA WHERE EmpUtente IS NOT NULL );

4.
SELECT U.Nome,
(SELECT COUNT(C.ISBN) FROM CÓPIA C
WHERE C.EmpUtente IS NOT NULL
AND C.EmpUtente = U.Num)
FROM UTENTE U;


-- 7.0

1.
DELETE FROM UTENTE
WHERE 0 = (SELECT COUNT(C.ISBN) FROM CÓPIA C WHERE C.EmpUtente = UTENTE.Num);

2.
DELETE FROM CÓPIA
WHERE ISBN = (SELECT ISBN FROM LIVRO WHERE Título = 'Astérix o Gaulês')
AND EmpUtente IS NULL;

3.
UPDATE CÓPIA
SET EmpUtente = NULL, EmpData = NULL
WHERE EmpUtente = (SELECT Num FROM UTENTE WHERE Nome = 'Pedro Costa');

4.
UPDATE CÓPIA
SET Estante = 'E12', Prateleira = 3
WHERE ISBN IN (SELECT ISBN FROM AUTORES WHERE Nome = 'Luís de Camões' OR  Nome = 'Fernando Pessoa');
-- foreign key error


-- 8.0

1.
SELECT U.Nome, L.Título FROM CÓPIA C
JOIN UTENTE U ON C.EmpUtente = U.Num
JOIN LIVRO L ON C.ISBN = L.ISBN;

2.
SELECT U.Nome, COUNT(C.ISBN) FROM CÓPIA C
JOIN UTENTE U ON C.EmpUtente = U.Num
GROUP BY U.Nome
ORDER BY U.Nome;

3.
SELECT A.Nome, L.Título FROM LIVRO L
JOIN AUTORES A ON L.ISBN = A.ISBN
ORDER BY A.Nome, L.Título;

4.
SELECT A.Nome, L.Título, COUNT(C.ISBN) FROM CÓPIA C
JOIN AUTORES A ON C.ISBN = A.ISBN
JOIN LIVRO L ON C.ISBN = L.ISBN
GROUP BY A.Nome, L.Título
ORDER BY A.Nome, L.Título;

5.
SELECT A.Nome, L.Título, COUNT(C.ISBN), COUNT(C.EmpUtente) FROM CÓPIA C
JOIN AUTORES A ON C.ISBN = A.ISBN
JOIN LIVRO L ON C.ISBN = L.ISBN
GROUP BY A.Nome, L.Título
ORDER BY A.Nome, L.Título;

6.
SELECT S.Código, COUNT(C.ISBN) FROM CÓPIA C 
JOIN PRATELEIRA P ON C.Estante = P.Estante
JOIN ESTANTE E ON C.Estante = E.Código
JOIN SECÇÃO S ON E.Secção = S.Código
GROUP BY S.Código; -- incompleto

7. (?)


-- 9.0

1.
CREATE VIEW ARRUMAÇÃO (Título, NumCópia, Prateleira, Estante) AS
SELECT L.Título, C.Num, C.Prateleira, C.Estante
FROM CÓPIA C
JOIN LIVRO L ON C.ISBN = L.ISBN
ORDER BY L.Título, C.Num;

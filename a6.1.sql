Drop DATABASE IF EXISTS Movies;
CREATE DATABASE Movies;
USE Movies;

/* Créer une nouvelle base de données nommée Movies. Dans cette base de données, à l’aide des instructions SQL
adéquates, créer une table artiste avec les champs suivants : id (valeur entière identifiante avec saisie obligatoire), nom
(chaîne de 30 caractères maximum avec saisie obligatoire), prenom (chaîne de 20 caractères maximum avec saisie
obligatoire), anneeNaiss (valeur entière). Empêcher que l’on puisse encoder deux artistes avec à la fois le même nom,
prénom et année de naissance.
Créer une table pays avec les champs suivants : code (chaîne de 4 caractères maximum servant d’identifiant et dont la
saisie est obligatoire), nom (chaîne de 30 caractères maximum avec saisie obligatoire), langue (chaîne de 30 caractères
maximum avec saisie obligatoire et l’anglais comme valeur par défaut), */

CREATE TABLE Artist(
    id int not null,
    name varchar(30) not null,
    firstName varchar(20) not null,
    birthYear int,
    PRIMARY KEY (id),
    CONSTRAINT UNIQUE (name,firstName,birthYear)
);

CREATE TABLE Country(
    code varchar(4) not null,
    name varchar(30) not null,
    language varchar(30) not null default 'English',
    PRIMARY KEY (code)
);

-- seed

INSERT INTO Artist(id, name, firstName, birthYear) VALUES
(1, 'Scott', 'Ridley', 1943),
(2, 'Hitchcock', 'Alfred', 1899),
(3, 'Kurosawa', 'Akira', 1910),
(4, 'Woo', 'John', 1946),
(5, 'Tarantino', 'Quentin', 1963),
(6, 'Cameron', 'James', 1954),
(7, 'Tarkowski', 'Andre', 1932),
(8, 'Pialat', 'Maurice', 1925),
(100, 'Eastwood', 'Clint', 1930),
(101, 'Hackman', 'Gene', 1930),
(102, 'Scott', 'Tony', 1930),
(103, 'Smith', 'Will', 1968),
(104, 'Winslet', 'Kate', 1975),
(105, 'DiCaprio', 'Leonardo', 1974);

INSERT INTO Country (code, name, language) VALUES
('INC', 'Inconnu', 'inconnue'),
('FR', 'France', 'français'),
('USA', 'Etats-Unis', 'anglais'),
('D', 'Allemagne', 'allemand'),
('GB', 'Grande-Bretagne', 'anglais'),
('JP', 'Japon', 'japonais'),
('AUS', 'Australie', 'anglais'),
('RUS', 'Russie', 'russe'),
('IRL', 'Irlande', 'anglais'),
('I', 'Italie', 'italien'),
('BF', 'Belgique', 'français'),
('BV', 'Belgique', 'néerlandais'),
('NL', 'Pays-Bas', 'néerlandais'),
('E', 'Espagne', 'espagnol');

/* Avec les instructions SQL adéquates, créer les tables nécessaires permettant de saisir les informations suivantes
concernant les films sachant que idfilm est un champ identifiant à valeur entière et saisie obligatoire, titre est une chaîne
de 50 caractères maximum avec saisie obligatoire, annee est un champ entier avec saisie obligatoire et ne pouvant
prendre ses valeurs que dans l’intervalle [1925 2025] et enfin que genre est une chaîne de 30 caractères maximum dont
la valeur ne peut être que Science-Fiction, Suspense, Drame, Policier, Western, Comédie, Action ou Thriller */

CREATE TABLE Movie(
    idfilm int not null,
    title varchar(50) not null,
    year int not null,
    genre varchar(30),
    idReal int not null,
    countryCode varchar(4),
    PRIMARY KEY (idfilm),
    FOREIGN KEY (idReal) REFERENCES artist(id) on delete set null,
    FOREIGN KEY (countryCode) REFERENCES country(code) on delete set null,
    CHECK ( year BETWEEN 1925 AND 2025 ),
    CHECK ( genre in ('Science-Fiction', 'Suspense', 'Drame', 'Policier', 'Western', 'Comedie', 'Action', 'Thriller') )
);

CREATE TABLE Role(
    idMovie int not null,
    idArtist int not null,
    role varchar(50),
    PRIMARY KEY (idMovie, idArtist),
    FOREIGN KEY (idMovie) REFERENCES Movie(idfilm) on delete cascade,
    FOREIGN KEY (idArtist) REFERENCES Artist(id) on delete cascade
);

-- seed

INSERT INTO Movie (idFilm, title, year, genre, idReal, countryCode) VALUES
(100, 'Alien', 1979, 'Science-Fiction', 1, 'USA'),
(101, 'Vertigo', 1958, 'Suspense', 2, 'USA'),
(102, 'Psychose', 1960, 'Suspense', 2, 'USA'),
(103, 'Kagemusha', 1980, 'Drame', 3, 'JP'),
(104, 'Volte-face', 1997, 'Thriller', 4, 'USA'),
(105, 'Pulp Fiction', 1995, 'Policier', 5, 'USA'),
(106, 'Van Gogh', 1991, 'Drame', 8, 'FR'),
(107, 'Titanic', 1997, 'Drame', 6, 'USA'),
(108, 'Sacrifice', 1986, 'Drame', 7, 'FR'),
(109, 'Josey Wales', 1976, 'Western', 100, 'USA');

INSERT INTO role (idMovie, idArtist, role) VALUES
(107, 104, 'Rose Dewitt-Bukater'),
(107, 105, 'Jack Dawson'),
(109, 100, 'Josey Wales');

SELECT
    m.idfilm,
    m.title,
    m.genre,
    CONCAT( r.name,' ', r.firstName) as Realisateur,
    c.name as Pays,
    COALESCE(GROUP_CONCAT(a.name ORDER BY a.id SEPARATOR ', '), '') AS Acteurs
FROM Movie m
LEFT JOIN artist r on m.idReal = r.id
LEFT JOIN Country c on m.countryCode = c.code
LEFT JOIN role ro on m.idfilm = ro.idMovie
LEFT JOIN Artist a on ro.idArtist = a.id
GROUP BY m.idfilm, m.title, m.genre, r.name, r.firstName, c.name
ORDER BY m.idfilm;

SELECT
    m.title,
    CONCAT(a.name, ' ', a.firstName) as Acteur,
    ro.role as Role
FROM Movie m
INNER JOIN Role ro on m.idfilm = ro.idMovie
INNER JOIN Artist a on ro.idArtist = a.id



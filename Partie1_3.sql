drop database if exists salarie;
create database salarie;
use salarie;


create table service(
    id int not null auto_increment,
    nom varchar(50) unique,
    primary key (id)
);

create table prenom(
    id int not null auto_increment,
    prenom varchar(50) unique,
    primary key (id)
);

create table section(
    id int not null auto_increment,
    idService int not null,
    nom varchar(50),
    primary key (id),
    foreign key (idService) references service(id) on delete cascade
);


create table employe(
    id INT not null AUTO_INCREMENT,
    idService int,
    idSection int,
    nom varchar(50) not null,
    idPrenomP int not null,
    email varchar(50) unique,
    telephone varchar(4),
    primary key (id),
    foreign key (idService) references service(id) on delete set null,
    foreign key (idSection) references section(id) on delete set null,
    foreign key (idPrenomP) references prenom(id) on delete restrict
);

alter table service ADD IdChef int references employe(id) on delete set null;


create table prenom_employe(
    idEmploye int not null,
    idPrenom int not null,
    ordre int not null default 1,
    primary key (idEmploye, idPrenom),
    foreign key (idEmploye) references employe(id) on delete cascade,
    foreign key (idPrenom) references prenom(id) on delete cascade
);

-- seed

INSERT INTO prenom (prenom) VALUES
( 'Eric'),
( 'Jean'),
( 'Luc'),
( 'Marie'),
( 'Claire'),
( 'Sophie'),
( 'Thomas'),
( 'Paul'),
( 'Henri'),
('Charles');

INSERT INTO service (nom) VALUES
('Informatique'),
('Comptabilité'),
('Production');

INSERT INTO section (idService, nom) VALUES
(1, 'Études'),
(1, 'Production'),
(3, 'Assemblage');

INSERT INTO employe (idService, idSection, nom, email, telephone) VALUES
(1, 1, 'Dupont', 'eric.dupont@entreprise.be', '4814'),       -- Eric (chef Informatique)
(1, 2, 'Martin', 'marie.martin@entreprise.be', NULL),        -- Sans téléphone (dépend d'Eric)
(2, NULL, 'Bernard', 'sophie.bernard@entreprise.be', '4820'),-- Chef Comptabilité (pas de section)
(2, NULL, 'Petit', 'thomas.petit@entreprise.be', NULL),      -- Sans téléphone (dépend de Sophie)
(3, 3, 'Durand', 'paul.durand@entreprise.be', '4855');

-- Attribution des chefs de service
UPDATE service SET idChef = 1 WHERE id = 1; -- Eric chef de l'Informatique
UPDATE service SET idChef = 3 WHERE id = 2; -- Sophie chef de la Comptabilité
UPDATE service SET idChef = 5 WHERE id = 3; -- Paul chef de la Production

-- Attribution des prénoms et de leur ordre dans l'état civil
INSERT INTO prenom_employe (idEmploye, idPrenom, ordre) VALUES
(1, 1, 1), -- Eric
(1, 2, 2), -- Jean (2e prénom d'Eric)
(1, 3, 3), -- Luc (3e prénom d'Eric)
(2, 4, 1), -- Marie
(2, 5, 2), -- Claire
(3, 6, 1), -- Sophie
(4, 7, 1), -- Thomas
(5, 8, 1), -- Paul
(5, 9, 2), -- Henri
(5, 10, 3),-- Charles
(5, 2, 4), -- Jean
(5, 3, 5); -- Luc (5 prénoms pour Paul, comme dans l'énoncé)

UPDATE employe SET idPrenomP = 1 WHERE id = 1; -- Eric
UPDATE employe SET idPrenomP = 4 WHERE id = 2; -- Marie
UPDATE employe SET idPrenomP = 6 WHERE id = 3; -- Sophie
UPDATE employe SET idPrenomP = 7 WHERE id = 4; -- Thomas
UPDATE employe SET idPrenomP = 8 WHERE id = 5; -- Paul
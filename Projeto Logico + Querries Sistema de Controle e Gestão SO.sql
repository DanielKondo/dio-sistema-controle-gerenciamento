CREATE DATABASE cgos;
USE cgos;

-- criando as tabelas do banco de dados

CREATE TABLE Clients(
			idClient int primary key auto_increment,
            clientName varchar(50) not null
);

CREATE TABLE ServiceOrder(
			idSO int primary key auto_increment,
            idClient int not null,
            emissionDate date not null,
            costValue float,
            orderStatus enum('pendente', 'em andamento', 'completo'),
            finishDate date not null
);

CREATE TABLE Team(
			idTeam int primary key auto_increment
);

CREATE TABLE Employee(
			idEmployee int primary key auto_increment,
            employeeName varchar(50) not null,
            adress varchar(255),
            expertise varchar(20),
            cost float not null,
			idTeam int not null,
            constraint fk_employee_team foreign key (idTeam) references Team(idTeam)
);

CREATE TABLE Vehicle(
			idVehicle int primary key auto_increment,
            document int not null
);

CREATE TABLE Parts(
			idParts int primary key auto_increment,
            partsName varchar(40) not null,
            partsCost float not null default 0
);

CREATE TABLE Service(
			idService int primary key,
            idVehicle int not null,
            idTeam int not null,
            serviceType enum('reparos','revisão') not null,
            hoursOfWork int not null,
            constraint fk_service_vehicle foreign key (idVehicle) references Vehicle(idVehicle),
            constraint fk_service_team foreign key (idTeam) references Team(idTeam)
);

CREATE TABLE ServicesOnOS(
			idSO int,
            idService int,
            primary key (idSO, idService),
            constraint fk_serviceon_os foreign key (idSO) references ServiceOrder(idSO),
            constraint fk_serviceon_service foreign key (idService) references Service(idService)
);

CREATE TABLE PartsUsed(
			idParts int,
            idService int,
            quantity int,
            primary key (idParts, idService),
            constraint fk_parts_used foreign key (idParts) references Parts(idParts),
            constraint fk_parts_service foreign key (idService) references Service(idService)
);

-- Populando o banco de dados

INSERT INTO Clients (clientName) VALUES ("Jailson");
INSERT INTO Clients (clientName) VALUES ("Josias");
INSERT INTO Clients (clientName) VALUES ("João");
INSERT INTO Clients (clientName) VALUES ("Julia");
INSERT INTO Clients (clientName) VALUES ("Jessica");

INSERT INTO Team VALUES ();

INSERT INTO Employee (employeeName, adress, expertise, cost, idTeam) VALUES ("José", "Rua Capitão Falcão", "Carros", 30, 1);
INSERT INTO Employee (employeeName, adress, cost, idTeam) VALUES ("Marco", "Rua Polo Aquático", 20, 1);
INSERT INTO Employee (employeeName, adress, expertise, cost, idTeam) VALUES ("Alexandre", "Rua Vigiar e Punir", "Caminhão", 50, 1);
INSERT INTO Employee (employeeName, adress, cost, idTeam) VALUES ("André", "Avenida 1º de Abril", 25, 1);
INSERT INTO Employee (employeeName, adress, expertise, cost, idTeam) VALUES ("Marta", "Rua dos Bandeirantes", "Moto", 75, 1);


INSERT INTO Vehicle (document) VALUES (666777);
INSERT INTO Vehicle (document) VALUES (888666);
INSERT INTO Vehicle (document) VALUES (131313);

INSERT INTO Parts (partsName, partsCost) VALUES ("A Peça que você pediu", 609);
INSERT INTO Parts (partsName, partsCost) VALUES ("Motor", 2500);
INSERT INTO Parts (partsName) VALUES ("Mola");

INSERT INTO Service (idService, idVehicle, idTeam, serviceType, hoursOfWork) VALUES (1, 1, 1, 'reparos', 10);
INSERT INTO Service (idService, idVehicle, idTeam, serviceType, hoursOfWork) VALUES (2, 2, 1, 'revisão', 2);
INSERT INTO Service (idService, idVehicle, idTeam, serviceType, hoursOfWork) VALUES (3, 3, 1, 'reparos', 15);

INSERT INTO PartsUsed VALUES (1, 2, 10);
INSERT INTO PartsUsed VALUES (2, 2, 1);
INSERT INTO PartsUsed VALUES (3, 1, 20);
INSERT INTO PartsUsed VALUES (2, 3, 1);
INSERT INTO PartsUsed VALUES (1, 3, 30);
INSERT INTO PartsUsed VALUES (2, 1, 2);

INSERT INTO ServiceOrder (idClient, emissionDate, costValue, orderStatus, finishDate) VALUES (2, '2022-08-10', 5000, 'completo', '2022-09-11');

INSERT INTO ServicesOnOS (idSO, idService) VALUES (1, 1);
INSERT INTO ServicesOnOS (idSO, idService) VALUES (1, 2);
INSERT INTO ServicesOnOS (idSO, idService) VALUES (1, 3);

-- utilizando querries

SELECT * FROM Clients;
SELECT * FROM Employee;
SELECT * FROM Vehicle;
SELECT * FROM Parts;
SELECT * FROM Service;
SELECT * FROM PartsUsed;
SELECT * FROM ServiceOrder;
SELECT * FROM ServicesOnOS;

SELECT * FROM Employee WHERE cost > 40;
SELECT employeeName FROM Employee ORDER BY cost DESC;


SELECT s.serviceType, SUM(p.partsCost*pu.quantity) as totalCost
FROM Parts as p
INNER JOIN PartsUsed as pu ON p.idParts = pu.idParts
INNER JOIN Service as s ON pu.idService = s.idService
GROUP BY s.serviceType

-- Criação do banco de dados para o cenário de E-commerce
create database ecommerce;
use ecommerce;

-- Criar tabela cliente
CREATE TABLE client(
IdClient INT AUTO_INCREMENT PRIMARY KEY,
Fname VARCHAR(15) NOT NULL,
Lname VARCHAR(20),
TypeClient ENUM('Pessoa física','Pessoa Jurídica'),
Address VARCHAR(30),
);

CREATE TABLE person(
idPerson INT AUTO_INCREMENT PRIMARY KEY,
person_idClient INT,
CPF char(11),
ContactP varchar(20),
birthDate date,
CONSTRAINT Fk_id_person foreign key(person_idClient) references client(IdClient),
CONSTRAINT UNIQUE_CPF_PERSON UNIQUE (CPF)
);

CREATE TABLE company(
idCompany INT AUTO_INCREMENT PRIMARY KEY,
company_idClient INT,
CNPJ char(14),
ContactC varchar(20),
CONSTRAINT Fk_id_person foreign key(company_idClient) references client(IdClient),
CONSTRAINT UNIQUE_CNPJ_COMPANY UNIQUE (CNPJ)
);

alter table client auto_increment=1;

-- Criar tabela produto  (size = dimensão do produto)
CREATE TABLE product(
IdProduct INT AUTO_INCREMENT PRIMARY KEY,
Pname VARCHAR(15) NOT NULL,
Classification_kids BOOL default false,
Category ENUM('Eletronics','Clothes','Toys','Foods','Furniture') not null,
Evaluation FLOAT default 0,
size VARCHAR(10)
);

-- Criar tabela pagamento

  CREATE TABLE payment(
Id_payment INT,
order_idOrder INT,
TypePayment ENUM('Cash','Boleto','Credit Card','Two Credit Cards'),
PaymentNumber INT NOT NULL,
PaymentValidity date NOT NULL,
primary key(Id_payment),
CONSTRAINT Fk_order_idOrderpayment foreign key(order_idOrder) references orders(IdOrder)
);


 -- Criar tabela pedido
 CREATE TABLE orders(
 IdOrder INT AUTO_INCREMENT PRIMARY KEY,
 IdOrderClient INT,
 OrderStatus ENUM('Canceled', 'Processing', 'Sent', 'Delivered') DEFAULT 'Processing',
 tracking_code varchar(45),
 OrderDescription VARCHAR(255),
 SendValue FLOAT DEFAULT 10,
 paymentCash BOOL default false,
 CONSTRAINT Fk_oders_client foreign key(IdOrderClient) references client(IdClient)
	on update cascade
 );
 
 
 -- Criar tabela Estoque
 CREATE TABLE productStorage(
 IdProdStorage INT AUTO_INCREMENT PRIMARY KEY,
 StorageLocation VARCHAR(45),
 Quantity INT default 0
 );
 
 -- Criar tabela Fornecedor
 CREATE TABLE supplier(
 IdSupplier INT AUTO_INCREMENT PRIMARY KEY,
 SocialName VARCHAR(255) NOT NULL,
 CNPJ char(15) NOT NULL,
 Contact CHAR(15) NOT NULL,
 CONSTRAINT unique_supplier UNIQUE (CNPJ)
 );
 
 -- Criar tabela Vendedor
 CREATE TABLE seller(
 IdSeller INT AUTO_INCREMENT PRIMARY KEY,
 SocialName VARCHAR(255) NOT NULL,
 AbstName VARCHAR(255),
 CNPJ char(15),
 CPF char(9),
 Location VARCHAR(255),
 Contact CHAR(15) NOT NULL,
 CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
 CONSTRAINT unique_cpf_seller UNIQUE (CPF)
 );
 
 -- Tabelas geradas a partir de um relacionamento
 
 CREATE TABLE productSeller(
 IdPseller INT,
 IdPproduct INT,
 ProdQuantity INT default 1,
 PRIMARY KEY (IdPseller, IdPproduct),
 CONSTRAINT fk_product_seller foreign key (IdPSeller) references seller (IdSeller),
 CONSTRAINT fk_product_product foreign key (IdPproduct) references product (IdProduct)
 );
 
 CREATE TABLE productOrder(
 idPOproduct INT,
 IDPOorder INT,
 poQuantity INT default 1,
 poStatus ENUM('Available', 'Not Available') default 'Available',
 PRIMARY KEY (idPOproduct,IDPOorder),
 CONSTRAINT fk_productOrder_product foreign key (idPOproduct) references product (IdProduct),
 CONSTRAINT fk_productOrder_order foreign key (IDPOorder) references orders (IdOrder)
 );
 
 CREATE TABLE storageLocation(
 idLproduct INT,
 IdLstorage INT,
 location VARCHAR(255) NOT NULL,
 PRIMARY KEY (idLproduct, IdLstorage),
 CONSTRAINT fk_storageLocation_product foreign key (idLproduct) references product (IdProduct),
 CONSTRAINT fk_storageLocation_storage foreign key (IdLstorage) references productStorage (IdProdStorage)
 );
 
 CREATE TABLE productSupplier(
 idPsSupplier INT,
 idPsProduct INT,
 Quantity INT NOT NULL,
 PRIMARY KEY (idPsSupplier,idPsProduct),
 CONSTRAINT fk_product_supplier_supplier foreign key (idPsSupplier) references supplier (IdSupplier),
 CONSTRAINT fk_product_supplier_product foreign key (idPsProduct) references product (IdProduct)
 
 );
 
 
 -- Inserindo informações
 use ecommerce;
 
 show tables;
 
 INSERT INTO Client (Fname,Minit,Lname,CPF,Address,Bdate)
	values ('Maria','M','Silva',123456789,'Rua Silva de prata 29','1978-10-23'),
			('Matheus','O','Pimentel',987654321,'Rua Alameda 289','1988-11-03'),
            ('Ricardo','F','Silva',45678913,'Avenida Alameda Vinha 1009','1998-12-17'),
            ('Julia','S','França',789123456,'Rua Lareijras 861','1982-03-01'),
            ('Roberta','G','Assis',98745631,'Avenida Koller 19','1993-06-20'),
            ('Isabela','M','Cruz',654789123,'Rua Alameda das flores 28','1989-09-13');
            
            
INSERT INTO product (Pname,Classification_kids,Category,Evaluation,size)
	values ('Fone ouvido', false, 'Eletronics','4',null),
			('Barbie Elsa', true, 'Toys','3',null),
			('Body Carters', true, 'Clothes','5',null),
			('Microfone Vedo', false, 'Eletronics','4',null),
			('Sofá retrátil', false, 'Furniture','3','3x57x80'),
			('Farinha arroz', false, 'Foods','2',null),
			('Fire Stick', False, 'Eletronics','3',null);
            
		
select * from client;
select * from product;

INSERT INTO orders (IdOrderClient, OrderStatus, OrderDescription,SendValue,paymentCash)
	values (1,default,'compra via aplicativo',null,1),
			(2,default,'compra via aplicativo',50,0),
            (3,'Sent',null,null,1),
            (4,default,'compra via web',150,0);
            
select * from orders;

INSERT INTO productOrder (idPOproduct,IDPOorder,poQuantity,poStatus)
	values (1,1,2,null),
			(2,1,1,null),
            (3,2,1,null);
            
INSERT INTO productStorage (StorageLocation,Quantity) 
	values ('Rio de Janeiro',1000),
			('Rio de Janeiro',500),
            ('São Paulo',10),
            ('São Paulo',100),
            ('São Paulo',10),
            ('Brasília',60);
            
INSERT INTO storageLocation(idLproduct,IdLstorage,location)
		values (1,2,'RJ'),
				(2,6,'GO');

INSERT INTO supplier (SocialName,CNPJ,Contact)
		values ('Almeida e Filhos','123456789123456','21985474'),
				('Eletrônicos Silva',854519649143457,'21985484'),
                ('Eletrônicos Valma',954519643632457,'21975474');
                
INSERT INTO productSupplier (idPsSupplier,idPsProduct,Quantity)
		values (1,1,500),
				(1,2,400),
                (2,4,633),
                (3,3,5),
                (2,5,10);

INSERT INTO seller(SocialName,AbstName,CNPJ,CPF,Location,Contact)
		values ('Tech Eletronics',null,123456789456783,null,'Rio de Janeiro',219946287),
				('Boutique Durgas',null,null,123456783,'Rio de Janeiro',219567895),
				('Kids World',null,456789123654485,null,'São Paulo',1198657484);
                
select * from seller;

INSERT INTO productSeller (IdPseller,IdPproduct,ProdQuantity)
		values (1,6,80),
				(2,7,10);
                
select * from productSeller;

INSERT INTO orders (IdOrderClient, OrderStatus, OrderDescription,SendValue,paymentCash)
	values (5,default,'Compra via aplicativo',null,1);
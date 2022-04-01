-- SQL Dialect : Microsoft SQL Server

create table City
(
    id   integer identity,
    name varchar(255) not null,
    primary key (id)
);

create table Institute
(
    id      integer identity,
    name    varchar(255) not null,
    type    varchar(255) not null,
    city    integer      not null,
    address varchar(255),
    website varchar(255),
    primary key (id)
);

alter table Institute
    add constraint FK_Institute_City foreign key (city) references City (id);

create table State
(
    id   integer identity,
    name varchar(255) not null,
    city integer      not null,
    primary key (id)
);

alter table State
    add constraint FK_State_City foreign key (city) references City (id);

create table [User]
(
    id        integer identity,
    mail      varchar(255) not null,
    password  varchar(255) not null,
    name      varchar(255),
    status    varchar(255) default 'not_verified',
    phone     varchar(255),
    type      varchar(255) not null,
    institute integer,
    city      integer,
    primary key (id)
);

alter table [User]
    add constraint FK_User_Institute foreign key (institute) references Institute (id);
alter table [User]
    add constraint FK_User_City foreign key (city) references City (id);

create table Role
(
    id   integer identity,
    name varchar(255) not null,
    primary key (id)
);

create table User_Role
(
    [user]     integer not null,
    role       integer not null,
    expiration datetime,
    primary key ([user], role)
);

alter table User_Role
    add constraint FK_User_Role_User foreign key ([user]) references [User] (id);
alter table User_Role
    add constraint FK_User_Role_Role foreign key (role) references Role (id);
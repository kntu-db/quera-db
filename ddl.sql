-- SQL Dialect : PostgreSQL

-- Authentication
create table City
(
    id   serial       not null,
    name varchar(255) not null,
    primary key (id)
);

create type InstituteType as enum
    (
        'university',
        'school',
        'institute'
        );

create table Institute
(
    id      serial        not null,
    name    varchar(255)  not null,
    type    InstituteType not null,
    city    integer       not null,
    address varchar(255),
    website varchar(255),
    primary key (id)
);

alter table Institute
    add constraint FK_Institute_City foreign key (city) references City (id);

create table State
(
    id   serial       not null,
    name varchar(255) not null,
    city integer      not null,
    primary key (id)
);

alter table State
    add constraint FK_State_City foreign key (city) references City (id);

create type UserStatus as enum
    (
        'active',
        'inactive',
        'not_verified'
        );

create type UserType as enum
    (
        'developer',
        'employer',
        'manager'
        );

create table "User"
(
    id        serial       not null,
    mail      varchar(255) not null,
    password  varchar(255) not null,
    name      varchar(255),
    status    UserStatus   not null default 'not_verified',
    phone     varchar(255),
    type      UserType     not null,
    institute integer,
    state     integer,
    unique (mail),
    primary key (id)
);

alter table "User"
    add constraint FK_User_Institute foreign key (institute) references Institute (id);
alter table "User"
    add constraint FK_User_State foreign key (state) references State (id);

create table Role
(
    id    serial       not null,
    title varchar(255) not null,
    primary key (id)
);

create table User_Role
(
    "user"     integer not null,
    role       integer not null,
    expiration timestamp,
    primary key ("user", role)
);

alter table User_Role
    add constraint FK_User_Role_User foreign key ("user") references "User" (id);
alter table User_Role
    add constraint FK_User_Role_Role foreign key (role) references Role (id);
-- End of authentication
-- ProblemSet
create table ProblemSet
(
    id            serial       not null,
    title         varchar(255) not null,
    description   text,
    start         timestamp    not null,
    "end"         timestamp,
    visibleScores boolean      not null default true,
    primary key (id)
);

create table HomeWork
(
    id    integer,
    class integer not null,
    primary key (id),
    
    class varchar(255) not null
);
alter table HomeWork add foreign key(class) refrences Class(id);
alter table HomeWork
    add constraint FK_HomeWork_ProblemSet foreign key (id) references ProblemSet (id);
-- alter table HomeWork
--     add constraint FK_HomeWork_Class foreign key (class) references Class (id);

create table Contest
(
    id      integer,
    sponsor varchar(255) not null,
    primary key (id)
);

alter table Contest
    add constraint FK_Contest_ProblemSet foreign key (id) references ProblemSet (id);

create table Participation
(
    "user"  integer not null,
    contest integer not null,
    primary key ("user", contest)
);

alter table Participation
    add constraint FK_Participation_User foreign key ("user") references "User" (id);
alter table Participation
    add constraint FK_Participation_Contest foreign key (contest) references Contest (id);

create table ProblemCategory
(
    id   serial       not null,
    name varchar(255) not null,
    primary key (id)
);

create table ProblemTag
(
    id   serial       not null,
    name varchar(255) not null,
    primary key (id)
);

create table Problem
(
    id       serial       not null,
    number   integer      not null,
    contest  integer      not null,
    title    varchar(255) not null,
    text     text,
    score    integer      not null,
    category integer      not null,
    unique (number, contest),
    primary key (id)
);

alter table Problem
    add constraint FK_Problem_Contest foreign key (contest) references Contest (id);
alter table Problem
    add constraint FK_Problem_ProblemCategory foreign key (category) references ProblemCategory (id);

create table Problem_Tag
(
    problem integer not null,
    tag     integer not null,
    primary key (problem, tag)
);

alter table Problem_Tag
    add constraint FK_Problem_Tag_Problem foreign key (problem) references Problem (id);
alter table Problem_Tag
    add constraint FK_Problem_Tag_Tag foreign key (tag) references ProblemTag (id);

create table Extension
(
    extension varchar(16)  not null,
    name      varchar(255) not null,
    primary key (extension)
);

create table Problem_Extension
(
    problem     integer     not null,
    extension   varchar(16) not null,
    timeLimit   integer,
    memoryLimit integer,
    primary key (problem, extension)
);

alter table Problem_Extension
    add constraint FK_Problem_Extension_Problem foreign key (problem) references Problem (id);
alter table Problem_Extension
    add constraint FK_Problem_Extension_Extension foreign key (extension) references Extension (extension);

create table Test
(
    number  integer      not null,
    problem integer      not null,
    title   varchar(255) not null,
    score   integer      not null,
    primary key (problem, number)
);

alter table Test
    add constraint FK_Test_Problem foreign key (problem) references Problem (id);

create table IoTest
(
    number  integer not null,
    problem integer not null,
    input   text,
    output  text,
    primary key (problem, number)
);

alter table IoTest
    add constraint FK_IoTest_Problem foreign key (problem, number) references Test (problem, number);

create table DockerizedTest
(
    number  integer      not null,
    problem integer      not null,
    image   varchar(255) not null,
    primary key (problem, number)
);

alter table DockerizedTest
    add constraint FK_DockerizedTest_Problem foreign key (problem, number) references Test (problem, number);

create type SubmitStatus as enum (
    'received',
    'queued',
    'running',
    'accepted'
    );

create type SubmitType as enum
    (
        'git',
        'upload'
        );


create table Submit
(
    problem   integer      not null,
    "user"    integer      not null,
    time      timestamp    not null,
    solveTime integer,
    status    SubmitStatus not null default 'queued',
    uri       varchar(255) not null,
    type      SubmitType   not null default 'upload',
    score     integer      not null,
    inContest boolean      not null,
    final     boolean      not null,
    primary key (problem, "user", time)
);

alter table Submit
    add constraint FK_Submit_Problem foreign key (problem) references Problem (id);
alter table Submit
    add constraint FK_Submit_User foreign key ("user") references "User" (id);

create type SubmitTestStatus as enum
    (
        'wrong-answer',
        'compilation-error',
        'runtime-error',
        'time-limit-exceeded',
        'memory-limit-exceeded',
        'accepted'
        );

create table Submit_Test
(
    problem integer     not null,
    number  integer     not null,
    "user"  integer     not null,
    time    timestamp   not null,
    status  SubmitTestStatus not null,
    primary key (problem, number, "user", time)
);

alter table Submit_Test
    add constraint FK_Submit_Test_Problem_Number foreign key (problem, number) references Test (problem, number);
alter table Submit_Test
    add constraint FK_Submit_Test_User foreign key (problem, "user", time) references Submit (problem, "user", time);
-- End of ProblemSet



--magnet
create table Company(
    name varchar UNIQUE ,
    founded_date date,
    logo varchar(255) not null ,
    website varchar(255) not null,
    description varchar(255) not null,

    employer varchar(255) not null,
    address varchar(255) not null,
    title varchar(255) not null,
    size int not null
);
alter table Company add foreign key (employer) references employer(mail);
alter table Company add foreign key (address) references Address(id);
alter table Company add foreign key (title) references Field(title);
alter table Company add foreign key (size) references CompanySize(id);

create table Relation_company_advantage(
    name varchar(255) not null,
    title varchar(255) not null
);
alter table Relation_company_advantage add foreign key (name) references Company(name);
alter table Relation_company_advantage add foreign key (title) references Advantage(title);

create table Relation_company_tech(
    name varchar(255) not null,
    title varchar(255) not null
);
alter table Relation_company_advantage add foreign key (name) references Company(name);
alter table Relation_company_advantage add foreign key (title) references Technology(title);




create table JobOffer(
    id serial primary key UNIQUE ,
    date date,
    level varchar(255) not null,
    cooperation varchar(255) not null,
    work_distance varchar(255) not null,
    rights varchar(255) not null,
    title varchar(255) not null,

    company_name varchar(255) not null,
    state varchar(255) not null
);
alter table JobOffer add foreign key (state) references State(name);
alter table JobOffer add foreign key (company_name) references Company(name);

create table Demand(
    description varchar(255) not null,
    date date,
    CV_URI varchar(255) not null,

    joboffer_id int not null,
    mail varchar(255) not null
);
alter table Demand add foreign key (joboffer_id) references JobOffer(id);
alter table Demand add foreign key (mail) references developer(mail);

create table Relation_joboffer_tech(
    job_ID varchar(255) not null,
    title varchar(255) not null
);
alter table Relation_joboffer_tech add foreign key (job_ID) references JobOffer(id);
alter table Relation_joboffer_tech add foreign key (title) references Technology(title);





create table Technology(
    title varchar(255) not null UNIQUE ,

    category varchar(255) not null
);
alter table Technology add foreign key (category) references TechnologyCategory(title);


create table TechnologyCategory(
    title varchar(255) not null UNIQUE
);

create table Field
(
    title varchar(255) not null UNIQUE
);

create table CompanySize
(
    id serial primary key not null UNIQUE ,
    minSize int not null ,
    maxSize int not null
);


create table Link
(
    id serial primary key not null UNIQUE ,
    URI  varchar(255) not null,

    title varchar(255) not null,
    name varchar(255) not null
);
alter table Link add foreign key (name) references Company(name);
alter table Link add foreign key (title) references LinkType(title);


create table LinkType(
    title varchar(255) not null UNIQUE ,
    logo varchar(255) not null
);


create table Advantage(
    title  varchar (255) not null UNIQUE
);

create table Address(
    id serial primary key not null UNIQUE ,
    Geo_point  varchar(255) not null,
    address varchar(255) not null,

    state varchar(255) not null
);
alter table Address add foreign key (state) references State(name);




create table Link
(
   id serial primary key not null UNIQUE ,
   URI varchar(255) not null,

   type varchar(255) not null
);
alter table Link add foreign key (type) references LinkType(title);

--end of magnet


--education

create table Semester(
    id serial primary key  not null  UNIQUE,
    turn varchar(255) not null ,
    from varchar(255) not null,
    to varchar(255)not null
);

create table Class(
    id serial primary key  not null UNIQUE ,
    title varchar(255)not null,
    prof varchar(255)not null,
    --primary key (title,prof),
    description varchar(255)not null,
    phone int not null,
    password varchar(255)not null,
    max_count int not null,
    archived varchar(255)not null,
    open_to_register varchar(255)not null,

    semester varchar(255)not null,
    institute varchar(255)not null
);
alter table Class add foreign key (semester) references Semester(id);
alter table Class add foreign key (institute) references Institute(name);


create table relationship_class_developer(
    student_number int not null,

    class varchar(255)not null,
    mail varchar(255)not null
);
alter table relationship_class_developer add foreign key (class) references Class(id);
alter table relationship_class_developer add foreign key (mail) references developer(mail);
--end of education

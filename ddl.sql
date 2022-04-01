-- SQL Dialect : Microsoft SQL Server

-- Authentication
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
    status    varchar(255) not null default 'not_verified',
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
-- End of authentication
-- ProblemSet
create table ProblemSet
(
    id            integer identity,
    title         varchar(255) not null,
    description   varchar(max),
    start         datetime     not null,
    end           datetime,
    visibleScores bit          not null default 1,
    primary key (id)
);

create table HomeWork
(
    id    integer,
    class integer not null,
    primary key (id)
);

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
    [user]  integer not null,
    contest integer not null,
    primary key ([user], contest)
);

alter table Participation
    add constraint FK_Participation_User foreign key ([user]) references [User] (id);
alter table Participation
    add constraint FK_Participation_Contest foreign key (contest) references Contest (id);

create table ProblemCategory
(
    id   integer identity,
    name varchar(255) not null,
    primary key (id)
);

create table ProblemTag
(
    id   integer identity,
    name varchar(255) not null,
    primary key (id)
);

create table Problem
(
    id       integer identity,
    number   integer      not null,
    contest  integer      not null,
    title    varchar(255) not null,
    text     varchar(max),
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
)

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
)

alter table Test
    add constraint FK_Test_Problem foreign key (problem) references Problem (id);

create table IoTest
(
    number  integer not null,
    problem integer not null,
    input   varchar(max),
    output  varchar(max),
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

create table Submit
(
    problem   integer      not null,
    [user]    integer      not null,
    time      datetime     not null,
    solveTime integer,
    status    integer      not null default 'queued',
    uri       varchar(255) not null,
    type      varchar(16)  not null,
    score     integer      not null,
    inContest bit          not null,
    final     bit          not null,
    primary key (problem, [user], time)
)

alter table Submit
    add constraint FK_Submit_Problem foreign key (problem) references Problem (id);
alter table Submit
    add constraint FK_Submit_User foreign key ([user]) references [User] (id);

create table Submit_Test
(
    problem integer     not null,
    number  integer     not null,
    [user]  integer     not null,
    time    datetime    not null,
    status  varchar(16) not null,
    primary key (problem, number, [user], time)
);

alter table Submit_Test
    add constraint FK_Submit_Test_Problem_Number foreign key (problem, number) references Test (problem, number);
alter table Submit_Test
    add constraint FK_Submit_Test_User foreign key (problem, [user], time) references Submit (problem, [user], time);
-- End of ProblemSet
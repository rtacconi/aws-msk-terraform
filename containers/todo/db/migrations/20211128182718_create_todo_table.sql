-- migrate:up
create table todos (
  id integer,
  name varchar(255) not null,
  done boolean not null
);

insert into todos (name, done) values ('Complete secrets mamangement', 'f');
insert into todos (name, done) values ('Buy milk', 'f');
insert into todos (name, done) values ('Buy beer', 'f');
insert into todos (name, done) values ('Walk three miles', 'f');

-- migrate:down
drop table todos;

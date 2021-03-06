## MYSQL创建索引原则

mysql的索引是为了形成B+树的数据结构，提高查询效率。但是一旦索引没有得到合适的创建，也将带来数据库死锁、宕机等危险。因此在创建索引时，我们应当遵循一些必要的原则：

1. 对于查询频率高的字段创建索引

2. 对排序、分组、联合查询频率高的字段创建索引

3. 索引的数量应当有所控制

   因为创建索引也是需要开销滴，每一个索引都会占用相应的物理空空间。

   过多的索引会增加数据插入、修改、删除的负担，降低执行效率。

4. 当需要多列索引时，需要注意，只有SQL中使用到前一个字段时，后一个字段的索引功能才会生效。我们可以使用explain命令对SQL进行分析是否正确使用到索引。

5. 选择唯一性索引，唯一性索引可以更快的搜索出对应的结果。

6. 用于创建索引字段的值要避免很长，太长的值也会影响到查询速度。

7. 在合适的时候对多余的索引进行清理。

## 普通索引和唯一索引的区别

对于普通索引，在查询到第一个符合条件的结果后，会继续向下查找

对于唯一索引，查询到第一个符合条件的结果后就立即返回。

> 实际生产中，创建唯一索引的目的并不是为了加快查询速度，而是为了避免数据重复，创造幂等条件等。如果仅仅是为了加快查询速度的话普通索引就够了

## 主键与唯一索引的区别

实际上主键就是唯一索引，唯一不同的就是在建表的时候主键使用primary，而唯一索引使用unique。

## 事务的ACID

事务是指对数据库的一组操作要么都执行，要么都不执行。

**原子性 Atomicity**

​	一个事务中的所有操作，要么全部完成，要么全部失败，不会结束在某个中间状态。

**一致性 Consistency**

​	一致性实际上就是保持原子性得到的一个结果，数据库的状态在一个事务执行前后总是从一个一致的状态变成另外一个一致的状态。

**隔离性 Isolation**（重要）

​	一个事务的操作的最后提交前，对于其他事务来说是不可见的。

**持久性 Durability**

​	当事务执行完成后，其对数据的更改应当永久保存下来

> 当两个事务同时修改同一数据时，只有一个事务会成功，另一个事务会失败，原因是数据库使用了CAS乐观锁机制。

## 事务的隔离性

如果事务的隔离性没有处理好，将会导致以下三个问题：

- **脏读**	事务A读取到事务B还未提交的数据

- **不可重复读（数据层面）**	事务A读取到age为20的值，事务B将该值修改为28，事务A再读取age时变为28导致同一事务读取同一个值得到不同的结果。

- **幻读（表层面）**	事务A读取到表中有1条数据，此时事务B向同一张表新增一条数据，此时事务A再来读时，数据变为2条，就像出现幻觉一样。

  > 不可重复读和幻读理解上很相似，他们的不同点在于不可重复读描述的是对一条数据的修改，而幻读强调的是对整条数据的插入或者删除。

对于不可重复读，只需要锁住即将发生修改的数据即可，而对于幻读，则需要锁住更大的范围。正是因为这个问题的存在，事务的隔离性分为四个级别：

- **读未提交**	事务中的修改，即使没有提交，别的事务也能看见，该隔离级别下，会造成脏读、不可重复读以及幻读。
- **读已提交**	事务中的修改只有在提交后，才会被其他事务看到。避免了脏读，但是无法避免不可重复读和幻读。
- **可重复读（MYSQL默认级别）**该级别能够保证在事务中看到的每行数据都和事务启动时看到的数据视图保持一致，但是这种级别下无法避免幻读。
- **串行化**	在该级别下，所有事务都是串行执行，只有上一个事务执行完成了，才会执行下一个事务，其可以解决所有并发问题。但是该级别需要靠大量的加锁实现（对同一行数据，读会增加读锁，写回增加写锁），导致效率低下。只有在需要绝对保证数据一致性以及并发量不大的情况下才可以考虑使用。

## Join（inner、left、right）的区别？

left join(左联接) 返回包括左表中的所有记录和右表中联结字段相等的记录。

right join(右联接) 返回包括右表中的所有记录和左表中联结字段相等的记录。

inner join(等值连接) 只返回两个表中联结字段相等的行。

## 慢查询

## 事务

## 读写分离和主从同步
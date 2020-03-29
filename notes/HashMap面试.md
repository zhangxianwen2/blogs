# MAP

## HashMap扩容机制

**一句话解答：当所需容量超过当前总容量的75%时，将总容量扩容为原来的2倍，然后重新计算元素在数组中的位置。**

​	当HashMap中的元素越来越多时，hash冲突的几率就会越来越高，因为数组的长度是固定的，所以为了提高查询效率，就要对HashMap的数组进行扩容。

​	当HashMap中的元素个数超过数组大小（数组总大小的length，不是数组中个数size）\*loadFactor时，就会进行数组扩容。loadFactor的默认值为0.75，也就是说，默认情况下，数组大小为16，那么当HashMap中的元素个数超过16\*0.75=12（这个值就是代码中的threshold值，也叫做临界值）的时候，就会把数组的大小扩展为2*16=32，即一倍，然后重新计算每个元素在数组中的位置。

​	0.75的取值基于大量的实验统计，当小于0.75时会造成资源的浪费，大于0.75时则会使得Map的get、put操作有一定的几率发生碰撞。

​	HashMap不是无限扩容的，当达到了实现预定的MAXIMUM_CAPACITY也就是1<<30=2^30，就不再进行扩容。为什么是2的30次方呢，两个原因：

1. hashMap定位位置时用的公式为hash&(length-1)，其中hash为待存储的数据的hash值，length为hashMap当前容量长度。我们都知道2的n次方再减一后的二进制数正好全是1，此时与其他任何不相同的数据进行与操作后，都能够保证结果不一样，若非2的n次方，则有可能导致不同的hash但是计算结果重复而导致hash碰撞也就是hash冲突。因此，HashMap的实现中，其长度就设计为2的n次方这样子。
2. HashMap内部由数组构成，在Java中，数组下标使用Int类型表示，因此，HashMap的容量最大值不得超过Int表示的最大值，而最接近这个最大值的2的n次方数据就是2的30次方。

## HashMap是否线程安全？

**一句话解答：不安全。**

由于线程不安全，在执行put操作或者resize时，会出现后一个线程覆盖前一个线程数据的情况。

put时：若两个线程同时向同一个数组地址插入元素，则两个线程将同时拿到同一个头结点，然后插入数据，此时先插入的数据就会被后插入的数据覆盖。
resize时：当多个线程同时因为HashMap长度到达阈值而触发resize方法重新调整数组长度时，就会在扩容后重新计算元素的存储位置，而最终只会有一个线程成功，其他线程的修改无效。特别是，当某线程已经完成扩容以及新的元素位置重新计算后，另一个线程才开始扩容操作，就会导致前一个线程的工作再一次被覆盖。

## 如何实现HashMap线程安全？

1. 使用HashTable，HashTable实现线程安全的原理是给整张Hash表添加synchroized关键字，但是这么做在多线程环境下十分影响效率，因此不推荐使用。

2. 通过Collections.synchroizedMap(new HashMap())接口获取一个线程安全的Map对象。该Map给相关操作增加了同步锁以实现线程安全，较影响效率。

3. 使用new ConcurrentHashMap()

   jdk7中，ConcurrentHashMap降低了锁操作的范围(颗粒度)，其内部使用段(Segment)表示不同的部分，每个部分就可以理解成一张小的HashTable，对每一次操作的锁都精确到segment上，如此则不会对其他线程操作其他segment造成影响。

   jdk8中，ConcurrentHashMap的结构调整为和HashMap一样的数组+链表+红黑树，并使用CAS结合synchronized关键字作用于单个Node节点实现，提高其并发效率。

   参考文章：https://www.cnblogs.com/heqiyoujing/p/11144396.html

## CAS原理（Compare And Swap，比较交换）

CAS原理可用于制作乐观锁，CAS有三个操作数，内存值V、预期值A、要修改的新值B，当且仅当A和V相等时才会将V修改为B，否则什么都不做。但是这会导致ABA问题(不理解上网查阅)的发生，因此一般情况下，我们会继续引入一个版本号的概念实现CAS原理，即不仅仅要满足A=V，还需要满足我们定义的版本号一致才能进行更改。

## LinkedHashMap

众所周知 [HashMap](https://github.com/crossoverJie/Java-Interview/blob/master/MD/HashMap.md) 是一个无序的 `Map`，因为每次根据 `key` 的 `hashcode` 映射到 `Entry` 数组上，所以遍历出来的顺序并不是写入的顺序。

因此 JDK 推出一个基于 `HashMap` 但具有顺序的 `LinkedHashMap` 来解决有排序需求的场景。

它的底层是继承于 `HashMap` 实现的，由一个双向链表所构成。

`LinkedHashMap` 的排序方式有两种：

- 根据写入顺序排序。
- 根据访问顺序排序。

其中根据访问顺序排序时，每次 `get` 都会将访问的值移动到链表末尾，这样重复操作就能得到一个按照访问顺序排序的链表。

总的来说 `LinkedHashMap` 其实就是对 `HashMap` 进行了拓展，使用了双向链表来保证了顺序性。

因为是继承与 `HashMap` 的，所以一些 `HashMap` 存在的问题 `LinkedHashMap` 也会存在，比如不支持并发等。

# SET

`HashSet` 是一个不允许存储重复元素的集合

```
    public boolean add(E e) {
        return map.put(e, PRESENT)==null;
    }
```

比较关键的就是这个 `add()` 方法。 可以看出它是将存放的对象当做了 `HashMap` 的健，`value` 都是相同的 `PRESENT` 。由于 `HashMap` 的 `key` 是不能重复的，所以每当有重复的值写入到 `HashSet` 时，`value` 会被覆盖，但 `key` 不会受到影响，这样就保证了 `HashSet` 中只能存放不重复的元素。

# LIST

## ArrayList

动态数组实现，可插入空数据。实现了RandomAccess接口可以随机访问，因此查询操作比较快。在执行add()方法时，当当前容量没有满，也不慢，但是当当前容量满时，就多了一个扩容操作降低速度。因此我们最好是一开始就给ArrayList指定好容量。

> RandomAccess接口是一个标记接口，被该接口标记的类将支持二分查找方法indexedBinarySearch()，而没有实现该接口的则使用iteratorBinarySearch()。

## LinkList

双向链表实现，插入删除只需要移动指针因此效率快，而查询操作由于需要遍历所有节点因此效率慢。


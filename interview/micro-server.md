[TOC]

#### 为什么网关Zuul之前还要配置Nginx?

*** Nginx反向代理，软负载，把请求均匀负载到多台Zuul的机器上。LVS和Nginx处于不同的负载维度，主要是运维工程师负责管理。数据库，MYSQL，
16C32G，物理机最佳，平时扛每秒几百请求，高峰期最多每秒扛三四千请求。扛几千请求时机器会负载很高，CPU，IO，网络负载很高。DBA在优化一下。

#### Dubbo用ZooKeeper, Spring Cloud用Eureka作为各种的注册中心，为什么要这样设计?

[](/interview/link/Zk&Eureka对比图.png)
    著名的CAP理论指出，一个分布式系统不可能同时满足C(一致性)、A(可用性)和P(分区容错性)。由于分区容错性在是分布式系统中必须要保证的，
因此我们只能在A和C之间进行权衡。在此Zookeeper保证的是CP, 而Eureka则是AP。
    Zookeeper的设计理念就是分布式协调服务，保证数据（配置数据，状态数据）在多个服务系统之间保证一致性，这也不难看出Zookeeper是属于CP
特性（Zookeeper的核心算法是Zab，保证分布式系统下，数据如何在多个服务之间保证数据同步）。Eureka是吸取Zookeeper问题的经验，先保证可用
性。
* Zookeeper作为服务发现的问题:
    对于服务发现而言，就是返回了包含不及时的信息结果也比什么都不返回要好！宁可返回某个服务5分钟之前在哪几个服务上可用的信息，也不能因
为暂时的网络故障而找不到可用的服务器而不返回结果。Zookeeper中，如果在同一个网络分区(partition)的节点数(nodes)数达不到Zookeeper选取
leader节点的法定人数时，它们会从zookeeper中断开，同时也就不能提供服务发现了。
* ZooKeeper三机房容灾5节点部署结构:
    [](/interview/link/ZooKeeper三机房容灾5节点部署结构.png)
    当同机房的ZK注册中心不可用，应用服务svcB无法注册到同机房ZK，就会访问ZK集群的其他节点，上图由于出现了网络分区故障，机房3无法与其他
机房通信,所以svcB不能注册到任何ZK上，而且应用服务svcA也无法访问任何ZK，无法调用svcB；此时，当机房3出现网络分区(Network Partitioned)
的时候，即机房3在网络上成了孤岛，我们知道虽然整体 ZooKeeper 服务是可用的，但是机房3的节点ZK5是不可写的，因为联系不上 Leader。因为机房
3节点ZK5不可写，这时候机房3的应用服务 svcB 是不可以新部署，重新启动，扩容或者缩容的，但是站在网络和服务调用的角度看，机房3的 svcA虽然
无法调用机房1和机房2的 svcB,但是与机房3的svcB之间的网络明明是 OK 的啊，为什么不让我调用本机房的服务？现在因为注册中心自身为了保脑裂(P)
下的数据一致性（C）而放弃了可用性，导致了同机房的服务之间出现了无法调用，这是绝对不允许的！可以说在实践中，注册中心不能因为自身的任何原
因破坏服务之间本身的可连通性。

#### Eureka原理?Eureka对等怎么同步?路由策略?

[](/interview/link/Eureka.png)
* 分布式系统数据在多个副本之间的复制方式主要有: 
    (1) 主从复制(Master-Slave)
    (2) 对等复制(Peer to Peer)[Eureka]
* 同步过程
    Eureka Server本身依赖了Eureka Client，也就是每个Eureka Server是作为其他Eureka Server的Client。Eureka Server启动后，会通过Eureka Client
请求其他Eureka Server节点中的一个节点，获取注册的服务信息，然后复制到其他peer节点。Eureka Server每当自己的信息变更后，例如Client向自己发起注册、续约、
注销请求， 就会把自己的最新信息通知给其他Eureka Server，保持数据同步。
* 怎么解决数据同步死循环?
    Eureka Server在执行复制操作的时候，使用HEADER_REPLICATION这个http header来区分普通应用实例的正常请求，说明这是一个复制请求，
这样其他peer节点收到请求时，就不会再对其进行复制操作，从而避免死循环。具体实现方式其实很简单，就是接收到Service Provider请求的Eureka Server，
把请求再次转发到其它的Eureka Server，调用同样的接口，传入同样的参数，除了会在header中标记isReplication=true，从而避免重复的replicate。
* 怎么解决数据冲突?serverA向serverB发起同步请求，如果A数据比B数据旧，不可能接受，B如何知道A数据旧，A又应该怎么解决?
    数据的新旧一般是通过版本号来定义的，Eureka是通过lastDirtyTimestamp这个类似版本号的属性来实现的，表示此服务实例最近一次变更时间。
比如A向B复制数据，数据冲突有2种情况:
    (1) A的数据比B的新，B返回404，A重新把这个应用实例注册到B。
    (2) A的数据比B的旧，B返回409，要求A同 B的数据。
hearbeat心跳机制:
    [](/interview/link/hearbeat心跳机制.png)
    即续约操作，来进行数据的最终修复，因为节点间的复制可能会出错，通过心跳就可以发现错误，进行弥补。例如发现某个应用实例数据与某个server
不一致，则server放回404，实例重新注册即可。
* Eureka数据存储结构
    [](/interview/link/Eureka数据存储结构.png)
    Eureka Client在拉取服务信息时，先从缓存层获取(相当于Redis)，如果获取不到，先把数据存储层的数据加载到缓存中(相当于 Mysql)，再
从缓存中获取。值得注意的是，数据存储层的数据结构是服务信息，而缓存中保存的是经过处理加工过的、可以直接传输到Eureka Client的数据结构。
    (1) 数据存储层
        因为rigistry本质上是一个双层的ConcurrentHashMap，存储在内存中的，所以是存储层不是持久层。第一层的key是spring.application.name（应用名）
    ，value 是第二层 ConcurrentHashMap；第二层 ConcurrentHashMap 的 key 是服务的 InstanceId(实例id)，value 是 Lease 对象；
    Lease 对象包含了服务详情和服务治理相关的属性。
    (2) 缓存层
        Eureka实现了二级缓存来保存即将要对外传输的服务信息，数据结构完全相同。一级缓存：ConcurrentHashMap<Key,Value> readOnlyCacheMap，
    本质上是HashMap，无过期时间，保存服务信息的对外输出数据结构。二级缓存：Loading<Key,Value> readWriteCacheMap，本质上是guava的缓存，
    包含失效机制，保存服务信息的对外输出数据结构。
* 缓存更新机制
        更新机制包含删除和加载两个部分，上图黑色箭头表示删除缓存的动作，绿色表示加载或触发加载的动作。删除二级缓存:Eureka Client发送
    register、renew和cancel请求并更新 registry 注册表之后，删除二级缓存；Eureka Server自身的Evict Task剔除服务后，删除二级缓存；
    二级缓存本身设置了guava的失效机制，隔一段时间后自己自动失效；加载二级缓存:Eureka Client 发送getRegistry请求后，如果二级缓存中
    没有，就触发guava的load，即从registry中获取原始服务信息后进行处理加工，再加载到二级缓存中。Eureka Server更新一级缓存的时候，如果
    二级缓存没有数据，也会触发guava的load。更新一级缓存:Eureka Server内置了一个TimerTask，定时将二级缓存中的数据同步到一级缓存
    （这个动作包括了删除和加载）。
* 服务注册机制
    服务提供者、服务消费者、以及服务注册中心自己，启动后都会向注册中心注册服务（如果配置了注册）。
    注册中心服务接收到register请求后:
    (1) 保存服务信息，将服务信息保存到registry中；
    (2) 更新队列，将此事件添加到更新队列中，供Eureka Client增量同步服务信息使用。
    (3) 清空二级缓存，即readWriteCacheMap，用于保证数据的一致性。
    (4) 更新阈值，供剔除服务使用。
    (5) 同步服务信息，将此事件同步至其他的Eureka Server节点。
* 服务续约机制
    服务注册后，要定时（默认30S，可自己配置）向注册中心发送续约请求，告诉注册中心“我还活着”，即续约。
    注册中心收到续约请求后:
    (1) 更新服务对象的最近续约时间，即Lease对象的lastUpdateTimestamp;
    (2) 同步服务信息，将此事件同步至其他的Eureka Server节点。
* 服务注销机制
    服务正常停止之前会向注册中心发送注销请求，告诉注册中心“我要下线了”。
    注册中心服务接收到cancel请求后:
    (1) 删除服务信息，将服务信息从registry中删除；
    (2) 更新队列，将此事件添加到更新队列中，供Eureka Client增量同步服务信息使用。
    (3) 清空二级缓存，即readWriteCacheMap，用于保证数据的一致性。
    (4) 更新阈值，供剔除服务使用。
    (5) 同步服务信息，将此事件同步至其他的Eureka Server节点。
* 服务剔除机制
    Eureka Server提供了服务剔除的机制，用于剔除没有正常下线的服务。
    Eureka自我保护机制是为了防止误杀服务而提供的一个机制。Eureka的自我保护机制“谦虚”的认为如果大量服务都续约失败，则认为是自己出问题了
（如自己断网了），也就不剔除了；反之，则是Eureka Client的问题，需要进行剔除。而自我保护阈值是区分Eureka Client还是Eureka Server出问
题的临界值:如果超出阈值就表示大量服务可用，少量服务不可用，则判定是Eureka Client出了问题。如果未超出阈值就表示大量服务不可用，则判定是
Eureka Server出了问题。
  执行剔除服务后:
    (1) 删除服务信息，从registry中删除服务。
    (2) 更新队列，将当前剔除事件保存到更新队列中。
    (3) 清空二级缓存，保证数据的一致性。
* 服务同步机制
    Eureka Client获取服务有两种方式，全量同步和增量同步。无论是全量同步还是增量同步，都是先从缓存中获取，如果缓存中没有，则先加载到缓
存中，再从缓存中获取。Eureka Server启动后，遍历eurekaClient.getApplications获取服务信息，并将服务信息注册到自己的registry中。
    (1) 启动时同步
        Eureka Server启动后，遍历eurekaClient.getApplications获取服务信息，并将服务信息注册到自己的registry中。
    (2) 运行过程中同步
        当Eureka Server节点有register、renew、cancel请求进来时，会将这个请求封装成TaskHolder放到acceptorQueue队列中，然后经过一
    系列的处理，放到batchWorkQueue中。TaskExecutor.BatchWorkerRunnable是个线程池，不断的从batchWorkQueue队列中poll出TaskHolder，
    然后向其他Eureka Server节点发送同步请求。
    
#### 怎么样定义一个微服务,或划分服务比较合理?业务导向的共性?

*** 对应服务拆分，先设计高内聚低耦合的领域模型(DD)，再实现相应的分布式系统是一种比较合理的方式。微服务是手段，不是目的。目的是为了让系
统更容易扩展，富有弹性，支持高并发，高可用，易于运维等等。使用DDD(领域驱动建模)进行业务建模，从业务中获取抽象的模型（例如用户，订单），
根据模型的关系进行划分界限上下文。界限上下文可理解为逻辑上得微服务，或单体应用中一个组件。
界限上下文评审原则:
    原则1: 上下文之间相互依赖越少越好，依赖上游不应该知道下游信息。（订单依赖商品，商品不应该知道订单信息）
    原则2: 使用潜在业务进行适配，如果能在一定程度响应业务变化，则证明该微服务可以在相当长一段时间内支撑应用开发。
    从DDD的界限上下文往微服务转化，并得到系统架构、API列表、集成方式等。拆分微服务是一个过程，内部高内聚，外部的解耦。要半年到一年才根
据对业务的深入理解进行合理的划分设计微服务。
* 设计微服务依赖关系
    被依赖的服务不需要知道调用方的信息，否则就不是一个合理的依赖。例如，用户服务对于访问他的来源不应该知晓，应该对订单、商品、物流等调
用方提供无差别的服务。
* 设计微服务的集成方式
    (1) 采用PRC远程调用方式集成(Dubbo, gRPC, Thrift等，耦合高)
    (2) 采用消息的方式集成(异步传输，订阅-发布)
    (3) 采用RESTful方式集成(HTTP协议，耦合低)

#### 为什么会有Dubbo和Spring Cloud两个微服务框架的存在,各自的优势?最重要的区别?

* Dubbo: 远程服务调用的分布式框架，专注RPC领域
    (1) 远程通讯: 长连接，NIO通讯，支持多种序列化(Hessian 2/ProtoBuf)，请求-响应模式交换信息。
    (2) 集群容错: 提供基于接口的RPC，负载均衡，失败容错(failover/failback)，地址路由，动态配置等。
    (3) 自动发现: 基于注册中心目录服务，服务消费者能动态查找服务提供者，地址透明，服务提供者可以平滑扩容缩容。
* Spring Cloud: 
    微服务全面解决方案，全家桶，服务注册与发现，网关路由，负载均衡，服务间调用，服务保护断路器，分布式配置管理，分布式链路追踪，分布式消息传递等
* 区别
    [](/interview/link/Dubbo&SpringCloud区别.png)
    (1) Dubbo是RPC通信，Spring Cloud是基于HTTP的REST方式。
    (2) 因为Dubbo采用单一长连接和NIO异步通讯（保持连接/轮询处理），使用自定义报文的TCP协议，并且序列化使用定制Hessian2框架，二进制传输，占用带宽少。
    适合于小数据量大并发的服务调用，以及服务消费者机器数远大于服务提供者机器数的情况，但不适用于传输大数据的服务调用。而Spring Cloud直接使用HTTP协议
    （但也不是强绑定，也可以使用RPC库，或者采用HTTP2.0+长链接方式（Feign可以灵活设置），JSON报文，消耗大。Dubbo的RPC痛点:服务提供方和调用方接口依赖
    太强;服务平台敏感，难以简单复用。
    (3) Dubbo强依赖阿里，社区更新不及时，现在又开始更新，未来会不会停，不好说。Spring Cloud属于Spring社区，开源社区活跃。基于Spring boot，
    快速开发部署，方便测试。
    
#### 什么是Hystrix?
*** Hystrix可以让我们在分布式系统中对服务间的调用进行控制，加入一些调用延迟或者依赖故障的容错机制。
* Hystrix 的设计原则
    (1) 对依赖服务调用时出现的调用延迟和调用失败进行控制和容错保护。
    (2) 在复杂的分布式系统中，阻止某一个依赖服务的故障在整个系统中蔓延。比如某一个服务故障了，导致其它服务也跟着故障。
    (3) 提供 fail-fast（快速失败）和快速恢复的支持。
    (4) 提供fallback优雅降级的支持。
    (5) 支持近实时的监控、报警以及运维操作。
* Hystrix更加细节的设计原则
    (1) 阻止任何一个依赖服务耗尽所有的资源，比如 tomcat 中的所有线程资源。
    (2) 避免请求排队和积压，采用限流和 fail fast 来控制故障。
    (3) 提供fallback降级机制来应对故障。
    (4) 使用资源隔离技术，比如bulkhead（舱壁隔离技术）、swim lane（泳道技术）、circuit breaker（断路技术）来限制任何一个依赖服务的故障的影响。
    (5) 通过近实时的统计/监控/报警功能，来提高故障发现的速度。
    (6) 通过近实时的属性和配置热修改功能，来提高故障处理和恢复的速度。
    (7) 保护依赖服务调用的所有故障情况，而不仅仅只是网络故障情况。
    
#### Hystrix资源隔离?

* 定义
    要把对某一个依赖服务的所有调用请求，全部隔离在同一份资源池内，不会去用其它资源了，这就叫资源隔离。哪怕对这个依赖服务，比如说商品服务，
现在同时发起的调用量已经到了 1000，但是线程池内就10个线程，最多就只会用这 10 个线程去执行。不会对商品服务的请求，因为接口调用延时，将
tomcat内部所有的线程资源全部耗尽。Hystrix进行资源隔离，其实是提供一个抽象，叫Command。把对某一个依赖服务的所有调用请求，全部隔离在同一
份资源池内，对这个依赖服务的所有调用请求，全部走这个资源池内的资源，不会去用其他的资源。
* Hystrix最基本的资源隔离技术，就是线程池隔离技术
    (1) 利用HystrixCommand获取单条数据
    (2) 利用HystrixObservableCommand批量获取数据
    [](/interview/link/Hystrix线程池隔离技术.png)
    从Nginx开始，缓存都失效了，那么Nginx通过缓存服务去调用商品服务。缓存服务默认的线程大小是10个，最多就只有10个线程去调用商品服务的接口。
即使商品服务接口故障了，最多就只有 10 个线程会 hang 死在调用商品服务接口的路上，缓存服务的 tomcat 内其它的线程还是可以用来调用其它的服务。
    (3) Hystrix实现资源隔离，主要有两种技术
        (a) 线程池
        (b) 信号量
        默认情况下，Hystrix使用线程池模式。
* 线程池机制
```
HystrixCommand command = new HystrixCommand(arg1, arg2); //HystrixCommand主要用于仅仅返回一个结果的调用
HystrixObservableCommand command = new HystrixObservableCommand(arg1, arg2); //HystrixObservableCommand主要用于可能会返回多条结果的调用
```
执行command要从4个方法选一个: execute(), queue(), observe(), toObservable()
    (1) execute(), queue()仅对HystrixCommand适用
    (2) execute(): 同步调用，调用后block，直到依赖服务返回单条结果或异常
    (3) queue(): 异步调用，返回一个Future，后面可以通过future获取结果
    (4) observe(): 订阅一个Observable对象，Observable代表是依赖服务的返回结果，获取一个代表结果的Observable对象的拷贝对象。是立即
    执行construct方法，拿到多行结果。
    (5) toObservable(): 返回一个Observab对象，没有执行construct方法，延迟调用。如果订阅这个对象subscribe方法时，才会执行command
    获取返回结果。
* 信号量机制
     信号量的资源隔离只是起到一个开关的作用。比如，服务A的信号量大小为10，那么就是说它同时只允许有10个tomcat线程来访问服务A，其它的请求
 都会被拒绝，从而达到资源隔离和限流保护的作用。
* 线程池与信号量区别
    [](/interview/link/线程池与信号量隔离的区别.png)
    线程池隔离技术，是用Hystrix自己的线程去执行调用；而信号量隔离技术，是直接让tomcat线程去调用依赖服务。信号量隔离，只是一道关卡，
信号量有多少，就允许多少个tomcat线程通过它，然后去执行。
    [](/interview/link/线程池与信号量区别.png)
    (1) 适用场景
        线程池技术，适合绝大多数场景，比如说我们对依赖服务的网络请求的调用和访问、需要对调用的timeout进行控制（捕捉timeout超时异常）。
    信号量技术，适合说你的访问不是对外部依赖的访问，而是对内部的一些比较复杂的业务逻辑的访问，并且系统内部的代码，其实不涉及任何的网络
    请求，那么只要做信号量的普通限流就可以了，因为不需要去捕获timeout类似的问题。
* Hystrix执行流程
    (1) Hystrix请求缓存(request cache)
        如果command开启了请求缓存，而且这个调用结果在缓存中存在，就直接从缓存返回结果
    (2) 短路器
        检测command对应的依赖服务是否打开短路器，如果打开，hystrix不执行command，执行fallback降级机制
    (3) 检测线程池/队列/semaphore是否满
        如果以上已满，不会执行command，直接执行fallback降级机制
    (4) 执行command
        如果基于线程池，有一个timeout机制。即HystrixCommand.run()或HystrixObservableCommand.construct()的执行，超过了timeout时
    长的话，那么command所在线程会抛出一个TimeoutException,timeout也会执行fallback降级机制，不会管run()或construct()返回值。
    (5) 注意点: 不可能终止Hystrix管理线程池中一个调用依赖服务timeout的线程，只能给外部抛出一个TimeoutException，由主线程来捕获再降级处理。
* 4种调用fallback的降级机制的时机
    (1) run()或construct()抛异常 
    (2) 短路器打开 
    (3) 线程池/队列/信号量满了 
    (4) command执行超时
    
#### Hystrix的8大执行流程

* 构建一个HystrixCommand或HystrixObservableCommand,HystrixCommand主要用于仅仅返回一个结果的调用,HystrixObservableCommand主要用
于可能会返回多条结果的调用
* 调用Command的执行方法,执行Command发起一次对依赖服务的调用,执行command要从4个方法选一个：execute(), queue(), observe(), toObservable()。
    (1) execute(),queue()仅对HystrixCommand适用;
    (2) execute(): 同步调用，调用后block，直到依赖服务返回单条结果或异常;
    (3) queue(): 异步调用，返回一个Future，后面可以通过future获取结果;
    (4) observe(): 订阅一个Observable对象，Observable代表是依赖服务的返回结果，获取一个代表结果的Observable对象的拷贝对象。是立即执行
    construct方法，拿到多行结果。
    (5) toObservable(): 返回一个Observab对象，没有执行construct方法，延迟调用。如果订阅这个对象subscribe方法时，才会执行command获取返回结果。
* 检查是否开启请求缓存
    如果开启request cache, 而这个调用结果在缓存中存在，那么直接从缓存中返回
* 检查是否开启短路器
    如果短路器打开，那么hystrix就不会执行command，直接执行fallback降级机制
* 检测线程池/队列/semaphore是否已满
    如果已满，不会执行command，而直接走fallback降级机制
* 执行command
    (1) 调用HystrixObservableCommand.construct()或HystrixCommand.run()来实际执行这个command。
    (2) HystrixCommand.run()返回一个单条结果，或者抛出一个异常
    (3) HystrixObservableCommand.construct()返回一个Observable对象，可以获取多条结果
    (4) 如果command执行超时，那么改线程会抛出TimeoutException，会执行fallback降级机制，不会管run()或construct()的返回值。
* 短路健康检查
    Hystrix会将每一个依赖服务的调用成功，失败，拒绝，超时等事件，都会发送给circuit breaker断路器。短路器就会对调用成功/失败/拒绝/超
时等事件的次数进行统计
* 调用fallback降级机制
    [](/interview/link/Hystrixfallback降级机制.png)
    (1) run()或construct()抛出一个异常
    (2) 短路器打开
    (3) 线程池/队列/信息量满
    (4) Command超时，Hystrix会调用fallback降级机制
    (5) 降级机制设置一些默认返回值
 
#### Hystrix核心技术之请求缓存

[](/interview/link/Hystrix核心技术请求缓存.png)
* 用法
    检测是否开启请求缓存(request cache)，是否由请求缓存，如果有，直接取缓存返回结果
* 概念
    请求上下文，每个web应用中, Hystrix在一个filter中，对每个请求增加一个请求上下文。Tomcat中每次请求，就是一个请求上下文。一个请求上
下文中会执行N多代码，调用N多个依赖服务。在一个请求上下文中，如果有多个command（假设参数一样，调用结构一样，返回结果也就一样），可以让
第一次的command执行返回的结果，缓存在内存中，然后这个请求上下文中，后续对这个command的执行都从内存中取缓存结果。
* 好处
    不用在一次请求上下文中反复多次执行一样的command，避免重复执行网络请求，提升整个请求的性能。
* 具体使用
    (1) 实现Hystrix请求上下文过滤器并注册
        (a) 定义HystrixRequestContextFilter类，实现Filter接口
            ```
            public class HystrixRequestContextFilter implements Filter{
                ...
            }
            ```
        (b) 然后将该filter对象注册到SpringBoot Application中
            ```
            @Bean
                public FilterRegistrationBean filterRegistrationBean() {
                    FilterRegistrationBean filterRegistrationBean = new FilterRegistrationBean(new HystrixRequestContextFilter());
                    filterRegistrationBean.addUrlPatterns("/*");
                    return filterRegistrationBean;
                }
            ```
    (2) command重写getCacheKey()方法
        ```
        public class GetProductInfoCommand extends HystrixCommand<ProductInfo> {
        
            private static final HystrixCommandKey KEY = HystrixCommandKey.Factory.asKey("GetProductInfoCommand");
                ...
                /**
                 * 每次请求的结果，都会放在Hystrix绑定的请求上下文上
                 *
                 * @return cacheKey 缓存key
                 */
                @Override
                public String getCacheKey() {
                    return "product_info_" + productId;
                }
            
                /**
                 * 将某个商品id的缓存清空
                 *
                 * @param productId 商品id
                 */
                public static void flushCache(Long productId) {
                    HystrixRequestCache.getInstance(KEY,
                            HystrixConcurrencyStrategyDefault.getInstance()).clear("product_info_" + productId);
                }
            }
        }
    ```

#### 基于本地缓存的fallback降级

* Hystrix出现以下四种情况，都会去调用fallback降级机制
    (1) 断路器处于打开的状态
    (2) 资源池已满（线程池+队列/信号量）
    (3) Hystrix调用各种接口，或者访问外部依赖，比如MySQL、Redis、Zookeeper、Kafka等等，出现了任何异常的情况。
    (4) 访问外部依赖的时候，访问时间过长，报了TimeoutException异常。
* 两种典型降级机制
    (1) 纯内存数据
        内存中维护一个 ehcache，作为一个纯内存的基于 LRU 自动清理的缓存，让数据放在缓存内，fallback从ehcache中获取数据
    (2) 默认值
        fallback直接返回一个默认值在HystrixCommand，降级逻辑的书写，是通过实现getFallback()接口；而在HystrixObservableCommand中，
    则是实现resumeWithFallback()方法。
 
#### Hystrix 断路器执行原理

* RequestVolumeThreshold请求数
```
HystrixCommandProperties.Setter().withCircuitBreakerRequestVolumeThreshold(int)   
```
表示在滑动窗口中，至少有多少个请求，才可能触发断路Hystrix经过断路器的流量超过了一定的阈值，才有可能触发断路。

* ErrorThresholdPercentage异常比例
```
HystrixCommandProperties.Setter().withCircuitBreakerErrorThresholdPercentage(int)
```
表示异常比例达到多少，才会触发断路，默认值是 50(%)。如果断路器统计到的异常调用的占比超过了一定的阈值，比如说在 10s 内，经过断路器的流
量达到了 30 个，同时其中异常访问的数量也达到了一定的比例，比如 60% 的请求都是异常（报错 / 超时 / reject），就会开启断路。

* SleepWindowInMilliseconds 断路休息时间
```
HystrixCommandProperties.Setter().withCircuitBreakerSleepWindowInMilliseconds(int)
```
断路开启，也就是由 close 转换到 open 状态（close -> open）。那么之后在 SleepWindowInMilliseconds 时间内，所有经过该断路器的请求全
部都会被断路，不调用后端服务，直接走 fallback 降级机制。而在该参数时间过后，断路器会变为 half-open 半开闭状态，尝试让一条请求经过断
路器，看能不能正常调用。如果调用成功了，那么就自动恢复，断路器转为 close 状态。 

* Enabled断路器开关
```
HystrixCommandProperties.Setter().withCircuitBreakerEnabled(boolean)
```
如果设置为true的话，直接强迫打开断路器，相当于是手动断路了，手动降级，默认值是false。

* ForceClosed手动断路开关: 关
```
HystrixCommandProperties.Setter().withCircuitBreakerForceClosed(boolean)
```
如果设置为 true，直接强迫关闭断路器，相当于手动停止断路了，手动升级，默认值是 false。

#### Hystrix线程池隔离与接口限流

[](/interview/link/Hystrix线程池隔离与接口限流.png)
    Hystrix 通过判断线程池或者信号量是否已满，超出容量的请求，直接 Reject 走降级，从而达到限流的作用。限流是限制对后端的服务的访问量，
比如说你对 MySQL、Redis、Zookeeper 以及其它各种后端中间件的资源的访问的限制，其实是为了避免过大的流量直接打死后端的服务。
* 线程隔离技术
    Hystrix 对每个外部依赖用一个单独的线程池，这样的话，如果对那个外部依赖调用延迟很严重，最多就是耗尽那个依赖自己的线程池而已，不会
影响其他的依赖调用。
* 线程池机制的优点
    (1) 隔离服务。任何一个依赖服务被隔离在线程池内，即使自己线程池资源满了，也不会影响其他服务调用。
    (2) 方便引入新的依赖服务。即使新的依赖服务有问题，也不影响其他服务调用。
    (3) 故障恢复。当一个有故障的服务变好后，可以通过清空线程池，快速恢复该服务调用。
    (4) 健康报告。线程池的健康状态随时报告，比如成功、失败、拒绝、超时的次数统计，然后接近实时的热修改调用配置，不用停机。
    (5) 基于线程池的异步本质，在同步调用之上，构建一层异步调用层。
* 线程池机制的缺点
    (1) 增加CPU开销。
    (2) 每个command的执行依托独立线程，会进行排队，调度，上下文切换。Hystrix官方统计过额外开销，相比于可用性和稳定性的提升，是可以接
    受的。Hystrix semaphore 技术可以用来限流和削峰，但是不能用来对调研延迟的服务进行timeout和隔离。
* 基于timeout机制为服务接口调用超时提供安全保护
    如果你不对各种依赖服务接口的调用做超时控制，来给你的服务提供安全保护措施，那么很可能你的服务就被各种垃圾的依赖服务的性能给拖死了。
 
#### Hystrix核心总结
* Hystrix内部工作原理，8大执行步骤和流程
* 资源隔离: 多个依赖服务，做资源隔离，避免任何一个依赖服务故障导致服务资源耗尽而崩溃，高可用。
* 请求缓存: 对同一个request内多个相同command，使用request cache，提供性能。
* 熔断: 基于断路器，采集异常情况，如报错，超时，拒绝，短路，一段时间不能访问，直接降级。
* 降级: 服务提供的容错机制，fallback逻辑。
* 限流: 通过线程池，或信号量，限制对某个后端服务或资源的访问量，直接降级。
* 超时: 避免因某个依赖服务性能太差，导致大量线程卡住在这个依赖服务。

#### 分布式事务实现的几种方案

*  两阶段提交方案/XA方案
    这种分布式事务方案，比较适合单块应用里。跨多个库的分布式事务，由于因为严重依赖于数据库层面来搞定复杂的事务，效率很低，绝对不适合高
并发的场景。如果要玩儿，那么基于 Spring + JTA 就可以搞定。这个方案，很少用，一般来说某个系统内部如果出现跨多个库的这么一个操作，是不合
规的。如果你要操作别人的服务的库，你必须是通过调用别的服务的接口来实现，绝对不允许交叉访问别人的数据库。
* TCC(Try, Confirm, Cancel)方案
    (1) 使用补偿机制,分三个阶段
        (a) Try阶段: 这个阶段说的是对各个服务的资源做检测以及对资源进行锁定或者预留。
        (b) Confirm阶段: 这个阶段说的是在各个服务中执行实际的操作。
        (c) Cancel阶段: 如果任何一个服务的业务方法执行出错，那么这里就需要进行补偿，就是执行已经执行成功的业务逻辑的回滚操作。(把那些执行成功的回滚)
    (2) 缺点
        与业务耦合太紧，事务回滚严重依赖自己的写的代码来回滚和补偿。
    (3) 适用场景
        与钱打交道的场景，支付，交易。需要TCC，严格保证分布式事务要么全部成功，要么全部自动回滚，严格保证资金的正确性。
* 本地消息表
    (1) 流程
        (a) A系统在处理本地事务的同时插入一条数据到消费表。
        (b) 然后A系统将这个消息发送到MQ。
        (c) B系统接收到消息后，在一个事务里，先往自己本地消息表插入一条记录，然后执行业务处理；如果这个消息已经被处理过，则消息表插入失败，
        事务回滚，保证不会重复处理消息。
        (d) 如果B系统处理成功，则更新自己本地消费表状态和A系统消费表状态。
        (e) 如果B系统处理失败，则不会更新消息表状态，A系统会定期扫描自己的消息表，如果有未处理的消息，会再次发送到MQ中，让B系统再次处理。
        (f) 这个方案保证最终一致性，哪怕B系统事务失败，但A会不断重发消息，直到B成功为止。
    (2) 缺点
        严重依赖数据库的消息表来管理事务。高并发场景怎么办，访问消息表瓶颈，不容易扩展。
* 可靠消息最终一致性方案(国内互联网流行)
    [](/interview/link/可靠消息最终一致性方案.png)
    (1) 定义
        不用本地消费表，直接基于MQ来实现事务。比如阿里的RocketMQ就支持消息事务
    (2) 流程
        (a) A系统发一个prepared消息到MQ，如果这个消息失败则直接取消操作。
        (b) 如果这个prepared消息发送成功，则执行本地事务，如果事务执行成功就发送confirm消息到MQ，如果失败就告诉MQ回滚消息。
        (c) 如果发送了confirm消息，则MQ让B系统消费这条confirm消息，然后执行本地事务。
        (d) MQ会定时轮询所有prepared消息，然后回调A系统接口，查看这个消息是回滚还是要重发一次confirm消息。一般情况A系统查看本地事务
        是否执行成功，如果回滚了，则消息也回滚。避免本地事务执行成功，而confirm消息发送失败。
        (e) 如果B系统事务失败，则不断重试直到成功。如果实在不行，则想办法通知A系统回滚，或发送报警由人工来手动回滚或补偿。
        
#### 你们公司怎么处理分布式事务?
*** 如果是严格资金场景，用的TCC方案； 如果是订单插入之后要调用库存服务更新库存，可以用可靠消息最终一致性方案。一般情况不应该使用分布式
事务，代码复杂，性能太差。普通的A调用B，C，D，根本不用做分布式事务。一般就是监控(发邮件，发短信报警)，记录日志(一旦出错，完整的日志)，
事后快速的定位，排查和解决方案，临时修复数据。比做分布式事务的成本要低很多。

#### CAP理论

[](/interview/link/CAP理论.png)
* 定义
    C: Consistency一致性
    A: Availability可用性
    P: Partition tolerance分区容错性
* 定理
    一个分布式系统不可能同时满足CAP三个要求，最多只能同时满足其中两项
* 选择
    (1) CA: 放弃分区容错性，所有数据放一个节点，退回单机模式。
    (2) CP: 放弃可用性，一旦网络故障，受影响服务需要等待恢复时间，系统处于不可用状态。
    (3) AP: 放弃一致性，这里指放弃强一致性，确保最终一致性。大多数分布式系统的选择。
    
#### BASE理论

* 定义
    BASE: Base Available(基本可用),Soft state(软状态),Eventually consistent(最终一致性)
* BASE是对CAP一致性和可用性权衡的结果
    (1) 基本可用: 指分布式系统出现不可预知故障时，允许损失部分可用性，响应时间合理延长，服务上适当降级。
    (2) 软状态: 允许分布式系统中的数据处于中间状态，允许各节点数据同步时存在延时。
    (3) 最终一致性: 允许系统中所有数据副本，在经过一段时间同步后，最终能够达到一个一致的状态。不需要实时保证系统的数据一致性。
    
#### 两阶段提交(2PC)

*** 数据库支持2PC，又叫XA transactions。MySQL从5.5版，Oracle从7版，SQL Server 2005开始支持。
* XA是一个两阶段提交协议，协议分两阶段:
    第一阶段: 事务协调器要求每个涉及到事务的数据库预提交/投票(pre commit)此操作，并反映是否可以提交。
    第二阶段: 事务协调器要求每个数据库提交数据。
    如果有任何一个数据库否决此次提交，那么所有数据库都会被要求回滚它们在此事务中的那部分信息。
* 预提交/投票阶段:
    [](/interview/link/2PC第一阶段.png)
    事务协调者(事务管理器)给每个参与者(资源管理器)发送 Prepare 消息，每个参与者要么直接返回失败(如权限验证失败)，要么在本地执行事务，
写本地的 redo 和 undo 日志，但不提交。
* 提交阶段: 
    [](/interview/link/2PC第二阶段.png)
    如果协调者收到了参与者的失败消息或者超时，直接给每个参与者发送回滚(Rollback)消息；否则，发送提交(Commit)消息；参与者根据协调者的
指令执行提交或者回滚操作，释放所有事务处理过程中使用的锁资源。(注意:必须在最后阶段释放锁资源)
* 2PC缺点
    (1) 同步阻塞
        执行过程中，所有节点都是事务阻塞的。
    (2) 单点故障
        (a) 协调者正常，参与者宕机
            协调者无法收集到所有参与者反馈，会陷入阻塞。
        (b) 协调者宕机，参与者正常
            无论哪个阶段，协调者挂了，则无法发送提交请求，参与者会陷入阻塞。
        (c) 协调者与参与者都宕机
            发生在第一阶段，由于参与者都没有真正commit，则可以重新选出协调者，再执行2PC。
            发生在第二阶段，并且挂了的参与者在挂之前并没有收到协调者指令。这种情况，新的协调者重新执行2PC。
            发生在第二阶段，有部分参与者已经commit，产生数据不一致(脑裂)。2PC无法解决！
            协调者发出commit后挂了，唯一接收到这条消息的参与者同时也挂了。则即使选举出新的协调者，这条事务状态也不确定，没人知道事务是否被已经提交。
            
#### 三阶段提交(3PC)

* 改进点
    (1) 同时在协调者和参与者引入超时机制。
    (2) 在2PC的第一阶段和第二阶段中插入一个准备阶段，保证了在最后提交阶段之前各参与者状态时一致的。
* 三个阶段
    (1) CanCommit阶段
        2PC的第一阶段是本地事务执行结束后，最后不Commit。3PC的CanCommit是指尝试获取数据库锁，如果可以就返回Yes，进入预备状态，否则返回No。
    (2) PreCommit阶段
        如果上一阶段所有参与者都返回Yes，则进入PreCommit阶段进行事务预提交。这里协调者和参与者都引入超时机制。假如有任何一个参与者向协
    调者发送No，或者等待超时之后，协调者还没有收到参与者响应，则执行事务中断。
    (3) DoCommit阶段
        真正进行事务提交,包括:
        (a) 协调者发送提交请求；
        (b) 参与者提交事务；
        (c) 参会者响应反馈(向协调者发送ACK)；
        (d) 协调者确定事务完成。
        
#### TCC事务

* 定义
    Try/Confirm/Cancel，可归纳为补偿型事务。
    (1) Try: 针对业务操作做检测(一致性)和资源预留(隔离性)。
    (2) Confirm:对业务进行确认提交。默认Try成功并开始执行Confirm，Confirm一定成功。
    (3) Cancel: 在业务执行错误，需要回滚时执行业务补偿，释放预留资源。
* 核心思想
    针对每个操作，都有有一个与其对应的确认和补偿(撤销)操作。
* 优点
    (1) 解决协调者单点故障的问题。
    (2) 引入超时后进行补偿，并不会锁定整个资源，事务颗粒的变小。
    (3) 通过补偿机制，由业务操作管理数据一致性。
* 缺点
    开发复杂，每个目标字段都需要一个预留(冻结)字段，需要写很多补偿代码，在一些业务场景不太好定义和处理。
* 使用场景
    钱，金融等对事务要求非常高的核心业务场景。
* 总结
    TCC使用于大部分接口是同步调用的场景，要么一起成功，要么一起回滚。但在实际系统中，可能服务之间的调用时异步的，通过消息中间件。
    
#### Zookeeper都有哪些使用场景?

* 分布式协调
    (1) 场景:
        A系统发请求到MQ，B系统消费之后，A系统怎么知道B系统的处理结果?
    (2) 解决方案:
        [](/interview/link/zk分布式协调.png)
        用Zookeeper实现分布式系统之间协调工作。A系统发请求之后，在Zookeeper上对某个节点的值注册监听器，一旦B系统处理完值后就修改Zookeeper
    的节点值，A系统就立马收到通知。
* 分布式锁
    (1) 场景: 
        对某一个数据需要2个修改操作，两台机器同时收到请求，但需要一台执行后另一台才能执行。
    (2) 解决方案:
        使用ZK分布式锁。机器A收到请求后，在ZK创建一个znode，接着执行操作；另外一个机器B也尝试创建znode，发现创建不了，注册这个锁的监
    听器，只能等待机器A执行完成之后再执行。ZK发现机器A释放锁后，ZK会通知机器B, 这样B可以获取锁。
    (3) 实现:
        [](/interview/link/zk分布式锁.png)
        zookeeper.create(path…)尝试创建临时节点，创建成功就获取锁；如果被别的客户端获取了，就注册一个监听器监听这个锁，可以尝试用
    CountDownLatch await或者别的方式等待，或者不断循环查询，如果监听这个节点被释放，就把latch countDown或者把等待release，重新尝
    试获取锁。也可以基于zookeeper的临时顺序节点来实现，不用while true的循环。多人竞争一把锁时，会排队，后面每个排队的都去监听排在自
    己前面那个人创建的znode。
* 元数据/配置信息管理
    (1) 场景:
        [](/interview/link/zk元数据配置信息管理.png)
        ZK可以作为很多系统的配置信息管理，比如Kafka, Storm，Dubbo。
* HA高可用
    (1) 场景: 
        [](/interview/link/zk高可用.png)
        大数据系统基于ZK开发HA高可用机制，比如Hadoop，HDFS，Yarm。一个进程/服务做主备两个，主挂了立马通过Zookeeper感知切换到备用进程或服务。
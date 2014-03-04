Cache
=====

https://github.com/mynameisxuqiang/Cache.git
1、这个适用于业务数据不常变化的工程
2、你可以把工程里边的过期时间(#define TIME_OUT (60 * 5))更改 这就为你工程缓存的最大时间，过期后需要手动删除
3、用到了MD5加密，需要引用外部库文件（ZRMD5）
4、结合进项目中后，应该先调读缓存方法 若值为空再调写缓存方法

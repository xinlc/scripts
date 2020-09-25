
## 家里内网穿透

实现步骤：

1. 家里网络一般是动态IP，首先需要运营商开通外网访问家里网络的能力（需要电话沟通）。
2. 外网能访问家里动态IP后，设置路由器（智慧沃家） NAT 映射，WAN测端口是外网端口如： `8800`（注意：不能设置80，8080，443 等需要备案端口，运营商不给开通），LAN侧端口家里服务器端口如：`80`，LAN侧IP地址设置为服务器内网IP地址如：`192.168.2.202`，协议TCP。
3. 如果配置没有问题，访问动态IP+WAN端口就能通了。
4. 由于是动态IP 会不定时更换，解决思路是绑定域名，定时检测IP是否更换，通过阿里云域名API动态修改域名解析。
5. `upGradeDNS.py` 脚本实现动态修改域名解析，一般会有几分钟延迟。

## 基于域名访问方案（且不带端口号访问）

1. 需要一台公网服务器，并绑定域名，如：www.xxx.com。
2. 内网服务动态IP，绑定域名为 intranet.xxx.com。
3. 在公网服务器安装 Ngxin 代理到内网域名。
4. 在内网服务安装 Nginx 代理内网服务器相关服务。
5. `upGradeDNS.py` 动态解析内网域名。
6. 不同的程序可以使用独立公网子域名，修改代理配置即可。

### 服务器代理配置

**公网 Ngxin 配置**

```conf
server {
  listen 80;

  server_name staging.xxx.com sandboxapi.xxx.com;

  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection 'upgrade';

  # 注意这里需要动态解析，不然Nginx 只会解析一次对动态IP不能更新
  resolver 114.114.114.114 223.5.5.5 valid=30s ipv6=off;
  set $mydomainurl "http://intranet.xxx.com:8800";
  location / {
    proxy_pass $mydomainurl;
  }
}
```

**内网 Ngxin 配置**

```conf
server {
  listen 80;

  server_name sandboxapi.xxx.cn;

  location / {
    proxy_pass http://172.17.0.1:8301;
    # include conf.d/proxy.conf;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    proxy_read_timeout 300s;
  }

  location = /heartbeat {
    return 200 "成功";
  }

  # swagger
  location = /doc.html {
    proxy_pass http://172.17.0.1:8301/doc.html;
    include conf.d/proxy.conf;
  }
  location ^~ /webjars/ {
    proxy_pass http://172.17.0.1:8301;
    include conf.d/proxy.conf;
  }
  location ^~ /swagger-resources/ {
    proxy_pass http://172.17.0.1:8301;
    include conf.d/proxy.conf;
  }
}
```

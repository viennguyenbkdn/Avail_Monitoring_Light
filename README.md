# Avail_Monitoring
- The repo is to guide about setup of Grafana/Prometheus to monitor your Avail Light node


### 1. Edit your running lightnode
- Create customize `config.yaml` file to use local otel.
- You can delete some unused items in newly create file `config.yaml`.

```
mkdir -p $HOME/avail_lightclient && mkdir -p $HOME/avail_lightclient/avail_path
cd $HOME/avail_lightclient
YOUR_SEED="Availlight" # Edit to yours
YOUR_AVAIL_PATH="$HOME/avail_lightclient/avail_path" # Edit to your actual path

sudo tee $HOME/avail_lightclient/config.yaml > /dev/null <<EOF
log_level = "info"
# Light client HTTP server host name (default: 127.0.0.1)
http_server_host = "127.0.0.1"
# Light client HTTP server port (default: 7000).
http_server_port = 7000
# Secret key for libp2p keypair. Can be either set to "seed" or to "key".
# If set to seed, keypair will be generated from that seed.
# If set to key, a valid ed25519 private key must be provided, else the client will fail
# If "secret_key" is not set, random seed will be used.
secret_key = { seed="$YOUR_SEED" }
# P2P service port (default: 37000).
port = 37000
# Configures AutoNAT behaviour to reject probes as a server for clients that are observed at a non-global ip address (default: false)
autonat_only_global_ips = false
# AutoNat throttle period for re-using a peer as server for a dial-request. (default: 1 sec)
autonat_throttle = 2
# Interval in which the NAT status should be re-tried if it is currently unknown or max confidence was not reached yet. (default: 10 sec)
autonat_retry_interval = 10
# Interval in which the NAT should be tested again if max confidence was reached in a status. (default: 30 sec)
autonat_refresh_interval = 30
# AutoNat on init delay before starting the first probe. (default: 5 sec)
autonat_boot_delay = 10
# Sets application-specific version of the protocol family used by the peer. (default: "/avail_kad/id/1.0.0")
identify_protocol = "/avail_kad/id/1.0.0"
# Sets agent version that is sent to peers. (default: "avail-light-client/rust-client")
identify_agent = "avail-light-client/rust-client"
# Vector of Light Client bootstrap nodes, used to bootstrap the DHT (mandatory field).
# bootstraps = [["12D3KooWE2xXc6C2JzeaCaEg7jvZLogWyjLsB5dA3iw5o3KcF9ds","/ip4/13.51.79.255/udp/39000"]]
bootstraps = []
# Vector of Relay nodes, which are used for hole punching
# relays = [["12D3KooWBETtE42fN7DZ5QsGgi7qfrN3jeYdXmBPL4peVTDmgG9b","/ip4/13.49.44.246/udp/39111"]]
relays = []
#RPC
full_node_rpc = ["http://127.0.0.1:9933"]
# WebSocket endpoint of a full node for subscribing to the latest header, etc (default: ws://127.0.0.1:9944).
full_node_ws = ["ws://127.0.0.1:9944"]
# ID of application used to start application client. If app_id is not set, or set to 0, application client is not started (default: 0).
app_id = 0
# Confidence threshold, used to calculate how many cells need to be sampled to achieve desired confidence (default: 92.0).
confidence = 92.0
# File system path where RocksDB used by light client, stores its data. (default: avail_path)
avail_path = "$YOUR_AVAIL_PATH"
# Prometheus
# prometheus_port = 9520
# OpenTelemetry Collector endpoint (default: http://127.0.0.1:4317)
ot_collector_endpoint = "http://127.0.0.1:4317"
# If set to true, logs are displayed in JSON format, which is used for structured logging. Otherwise, plain text format is used (default: false).
log_format_json = true
# Fraction and number of the block matrix part to fetch (e.g. 2/20 means second 1/20 part of a matrix). This is the parameter that determines whether the client behaves as fat client or light client (default: None)
block_matrix_partition = "1/20"
# Disables proof verification in general, if set to true, otherwise proof verification is performed. (default: false).
disable_proof_verification = false
# Disables fetching of cells from RPC, set to true if client expects cells to be available in DHT (default: false)
disable_rpc = false
# Number of parallel queries for cell fetching via RPC from node (default: 8).
query_proof_rpc_parallel_tasks = 8
# Maximum number of cells per request for proof queries (default: 30).
max_cells_per_rpc = 30
# Maximum number of parallel tasks spawned for GET and PUT operations on DHT (default: 20).
dht_parallelization_limit = 20
# Number of records to be put in DHT simultaneously (default: 100)
put_batch_size = 100
# Number of seconds to postpone block processing after the block finalized message arrives. (default: 0).
block_processing_delay = 0
# Starting block of the syncing process. Omitting it will disable syncing. (default: None).
sync_start_block = 0
# Enable or disable synchronizing finality. If disabled, finality is assumed to be verified until the
# starting block at the point the LC is started and is only checked for new blocks. (default: true)
sync_finality_enable = true
# Time-to-live for DHT entries in seconds (default: 24h).
# Default value is set for light clients. Due to the heavy duty nature of the fat clients, it is recommended to be set far below this value - not greater than 1hr.
# Record TTL, publication and replication intervals are co-dependent: TTL >> publication_interval >> replication_interval.
record_ttl = 86400
# Sets the (re-)publication interval of stored records, in seconds. This interval should be significantly shorter than the record TTL, ensure records do not expire prematurely. (default: 12h).
# Default value is set for light clients. Fat client value needs to be inferred from the TTL value.
# This interval should be significantly shorter than the record TTL, to ensure records do not expire prematurely.
publication_interval = 43200
# Sets the (re-)replication interval for stored records, in seconds. This interval should be significantly shorter than the publication interval, to ensure persistence between re-publications. (default: 3h).
# Default value is set for light clients. Fat client value needs to be inferred from the TTL and publication interval values.
# This interval should be significantly shorter than the publication interval, to ensure persistence between re-publications.
replication_interval = 10800
# The replication factor determines to how many closest peers a record is replicated. (default: 20).
replication_factor = 20
# Sets the amount of time to keep connections alive when they're idle. (default: 30s).
# NOTE: libp2p default value is 10s, but because of Avail block time of 20s the value has been increased
connection_idle_timeout = 30
# Sets the timeout for a single Kademlia query. (default: 60s).
query_timeout = 60
# Sets the allowed level of parallelism for iterative Kademlia queries. (default: 3).
query_parallelism = 3
# Sets the Kademlia caching strategy to use for successful lookups. If set to 0, caching is disabled. (default: 1).
caching_max_peers = 1
# Require iterative queries to use disjoint paths for increased resiliency in the presence of potentially adversarial nodes. (default: false).
disjoint_query_paths = false
# The maximum number of records. (default: 2400000).
# The default value has been calculated to sustain ~1hr worth of cells, in case of blocks with max sizes being produces in 20s block time for fat clients
# (256x512) * 3 * 60
max_kad_record_number = 2400000
# The maximum size of record values, in bytes. (default: 8192).
max_kad_record_size = 8192
# The maximum number of provider records for which the local node is the provider. (default: 1024).
max_kad_provided_keys = 1024
EOF  
```

### 2. Create systemd service of lightnode
```
sudo tee /etc/systemd/system/availightd.service > /dev/null <<EOF
[Unit]
Description=Avail Light Client
After=network-online.target

[Service]
User=$USER
ExecStart=$(which avail-light) --config $HOME/avail_lightclient/config.yaml --network goldberg
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

### 3. Start lightnode
```
sudo systemctl daemon-reload
sudo systemctl enable availightd
sudo systemctl restart availightd
```

### 4. Install monitoring system
```
cd $HOME
curl -s https://raw.githubusercontent.com/viennguyenbkdn/Avail_Monitoring_Light/main/avail_light_monitoring_setup.sh | bash
```

### 5. Login Grafana dashboard
- Login to your **Grafana** => **DashBoard** > **Browse** => Select template "**Avail Metrics Light**"
![image](https://github.com/viennguyenbkdn/Avail_Monitoring_Light/assets/91453629/c257fe9f-efb7-4ea6-bd36-4c7818f3e741)

### 6. Query metrics by command line
- Command is to query
```
curl -s localhost:8889/metrics
```
- Output log
```
...
# HELP promhttp_metric_handler_requests_total Total number of scrapes by HTTP status code.
# TYPE promhttp_metric_handler_requests_total counter
promhttp_metric_handler_requests_total{code="200",instance="node-exporter:9100",job="node-exporter"} 841
promhttp_metric_handler_requests_total{code="500",instance="node-exporter:9100",job="node-exporter"} 0
promhttp_metric_handler_requests_total{code="503",instance="node-exporter:9100",job="node-exporter"} 0
# HELP rpc_call_duration
# TYPE rpc_call_duration gauge
rpc_call_duration{ip="",job="unknown_service",multiaddress="",peerID="12D3KooWRmSc13j2jtgVuLh3oVVFWERDvbKoBWYeX9WLdYEXEedr",role="lightnode",version="1.7.3"} 0.047963293
rpc_call_duration{ip="xxx.xxx.xxx.xxx",job="unknown_service",multiaddress="/ip4/xxx.xxx.xxx.xxx/udp/37000/quic-v1/p2p/12D3KooWRmSc13j2jtgVuLh3oVVFWERDvbKoBWYeX9WLdYEXEedr",peerID="12D3KooWRmSc13j2jtgVuLh3oVVFWERDvbKoBWYeX9WLdYEXEedr",role="lightnode",version="1.7.3"} 0.06077248
# HELP scrape_duration_seconds Duration of the scrape
# TYPE scrape_duration_seconds gauge
scrape_duration_seconds{instance="node-exporter:9100",job="node-exporter"} 0.115166953
# HELP scrape_samples_post_metric_relabeling The number of samples remaining after metric relabeling was applied
# TYPE scrape_samples_post_metric_relabeling gauge
scrape_samples_post_metric_relabeling{instance="node-exporter:9100",job="node-exporter"} 1708
# HELP scrape_samples_scraped The number of samples the target exposed
# TYPE scrape_samples_scraped gauge
scrape_samples_scraped{instance="node-exporter:9100",job="node-exporter"} 1708
# HELP scrape_series_added The approximate number of new series in this scrape
# TYPE scrape_series_added gauge
scrape_series_added{instance="node-exporter:9100",job="node-exporter"} 1708
# HELP session_block_counter_total
# TYPE session_block_counter_total counter
session_block_counter_total{ip="",job="unknown_service",multiaddress="",peerID="12D3KooWRmSc13j2jtgVuLh3oVVFWERDvbKoBWYeX9WLdYEXEedr",role="lightnode",version="1.7.3"} 1
session_block_counter_total{ip="xxx.xxx.xxx.xxx",job="unknown_service",multiaddress="/ip4/xxx.xxx.xxx.xxx/udp/37000/quic-v1/p2p/12D3KooWRmSc13j2jtgVuLh3oVVFWERDvbKoBWYeX9WLdYEXEedr",peerID="12D3KooWRmSc13j2jtgVuLh3oVVFWERDvbKoBWYeX9WLdYEXEedr",role="lightnode",version="1.7.3"} 274
# HELP target_info Target metadata
# TYPE target_info gauge
target_info{http_scheme="http",instance="node-exporter:9100",job="node-exporter",net_host_name="node-exporter",net_host_port="9100"} 1
# HELP total_block_number
# TYPE total_block_number gauge
total_block_number{ip="",job="unknown_service",multiaddress="",peerID="12D3KooWRmSc13j2jtgVuLh3oVVFWERDvbKoBWYeX9WLdYEXEedr",role="lightnode",version="1.7.3"} 62154
total_block_number{ip="xxx.xxx.xxx.xxx",job="unknown_service",multiaddress="/ip4/xxx.xxx.xxx.xxx/udp/37000/quic-v1/p2p/12D3KooWRmSc13j2jtgVuLh3oVVFWERDvbKoBWYeX9WLdYEXEedr",peerID="12D3KooWRmSc13j2jtgVuLh3oVVFWERDvbKoBWYeX9WLdYEXEedr",role="lightnode",version="1.7.3"} 62428
# HELP up The scraping was successful
# TYPE up gauge
up{instance="node-exporter:9100",job="node-exporter"} 1
....
```

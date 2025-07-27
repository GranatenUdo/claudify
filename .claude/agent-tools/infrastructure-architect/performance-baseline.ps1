# Performance Baseline Generator - Creates performance baselines and monitoring configs
# Adapts to different application types and platforms

param(
    [string]$ApplicationPath = ".",
    [string]$ApplicationType = "auto",  # auto, web-api, microservices, batch, realtime
    [string]$Platform = "auto",         # auto, kubernetes, docker, vm
    [switch]$GenerateAlerts,
    [switch]$GenerateDashboard,
    [switch]$LoadTest,
    [switch]$Verbose
)

Write-Host "📊 Performance Baseline Generator" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Auto-detect application type
if ($ApplicationType -eq "auto") {
    Write-Host "`nDetecting application type..." -ForegroundColor Yellow
    
    $indicators = @{
        "web-api" = @("*Controller.cs", "app.js", "server.py", "routes", "endpoints")
        "microservices" = @("docker-compose*.yml", "kubernetes", "service-mesh")
        "batch" = @("*Job.cs", "worker", "queue", "batch")
        "realtime" = @("websocket", "signalr", "socket.io", "grpc")
    }
    
    foreach ($type in $indicators.Keys) {
        foreach ($pattern in $indicators[$type]) {
            if (Get-ChildItem -Path $ApplicationPath -Include $pattern -Recurse -ErrorAction SilentlyContinue) {
                $ApplicationType = $type
                Write-Host "✓ Detected $ApplicationType application" -ForegroundColor Green
                break
            }
        }
        if ($ApplicationType -ne "auto") { break }
    }
    
    if ($ApplicationType -eq "auto") { $ApplicationType = "web-api" }  # Default
}

# Initialize baseline configuration
$baseline = @{
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    ApplicationType = $ApplicationType
    Platform = $Platform
    Metrics = @{
        ResponseTime = @{
            Target_P50 = 0
            Target_P95 = 0
            Target_P99 = 0
        }
        Throughput = @{
            RequestsPerSecond = 0
            ConcurrentUsers = 0
            PeakLoad = 0
        }
        Resources = @{
            CPU_Limit = 0
            Memory_Limit = 0
            CPU_Request = 0
            Memory_Request = 0
        }
        Availability = @{
            Uptime_Target = "99.9%"
            Error_Rate_Threshold = "0.1%"
            Timeout_Seconds = 30
        }
    }
    SLOs = @()
    Alerts = @()
    Dashboards = @()
    LoadTestScenarios = @()
}

# Set baseline targets based on application type
switch ($ApplicationType) {
    "web-api" {
        $baseline.Metrics.ResponseTime = @{
            Target_P50 = 100   # ms
            Target_P95 = 500   # ms
            Target_P99 = 1000  # ms
        }
        $baseline.Metrics.Throughput = @{
            RequestsPerSecond = 100
            ConcurrentUsers = 1000
            PeakLoad = 200  # RPS
        }
        $baseline.Metrics.Resources = @{
            CPU_Limit = "1000m"      # 1 CPU
            Memory_Limit = "1Gi"
            CPU_Request = "100m"     # 0.1 CPU
            Memory_Request = "256Mi"
        }
        
        $baseline.SLOs += @{
            Name = "API Response Time"
            Target = "95% of requests < 500ms"
            Measurement = "http_request_duration_seconds"
        }
        $baseline.SLOs += @{
            Name = "API Availability"
            Target = "99.9% uptime"
            Measurement = "up{job='api'}"
        }
    }
    
    "microservices" {
        $baseline.Metrics.ResponseTime = @{
            Target_P50 = 50    # ms (per service)
            Target_P95 = 200   # ms
            Target_P99 = 500   # ms
        }
        $baseline.Metrics.Throughput = @{
            RequestsPerSecond = 1000  # Total across services
            ConcurrentUsers = 5000
            PeakLoad = 2000
        }
        
        $baseline.SLOs += @{
            Name = "End-to-End Latency"
            Target = "95% of requests < 1s"
            Measurement = "trace_duration_seconds"
        }
        $baseline.SLOs += @{
            Name = "Service Mesh Success Rate"
            Target = "99.95% success rate"
            Measurement = "istio_request_total"
        }
    }
    
    "batch" {
        $baseline.Metrics = @{
            JobDuration = @{
                Target_P50 = 300   # seconds
                Target_P95 = 600   # seconds
                Target_P99 = 900   # seconds
            }
            Throughput = @{
                JobsPerHour = 100
                RecordsPerSecond = 1000
                ParallelJobs = 10
            }
        }
        
        $baseline.SLOs += @{
            Name = "Job Completion Rate"
            Target = "99% successful completion"
            Measurement = "job_completion_total"
        }
    }
    
    "realtime" {
        $baseline.Metrics.ResponseTime = @{
            Target_P50 = 10    # ms
            Target_P95 = 50    # ms
            Target_P99 = 100   # ms
        }
        $baseline.Metrics.Throughput = @{
            MessagesPerSecond = 10000
            ConcurrentConnections = 10000
            PeakLoad = 50000  # MPS
        }
        
        $baseline.SLOs += @{
            Name = "Message Latency"
            Target = "99% of messages < 100ms"
            Measurement = "websocket_message_latency"
        }
    }
}

# Platform-specific configurations
Write-Host "`nConfiguring for platform: $Platform" -ForegroundColor Yellow

if ($Platform -eq "kubernetes" -or (Test-Path (Join-Path $ApplicationPath "*.yaml") -ErrorAction SilentlyContinue)) {
    $Platform = "kubernetes"
    
    # Kubernetes-specific metrics
    $baseline.PlatformMetrics = @{
        Pods = @{
            Min_Replicas = 2
            Max_Replicas = 10
            Target_CPU_Utilization = 70
        }
        Resources = @{
            Requests_CPU = $baseline.Metrics.Resources.CPU_Request
            Requests_Memory = $baseline.Metrics.Resources.Memory_Request
            Limits_CPU = $baseline.Metrics.Resources.CPU_Limit
            Limits_Memory = $baseline.Metrics.Resources.Memory_Limit
        }
    }
    
    # Generate HPA configuration
    $hpaConfig = @"
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ${ApplicationType}-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ${ApplicationType}-deployment
  minReplicas: $($baseline.PlatformMetrics.Pods.Min_Replicas)
  maxReplicas: $($baseline.PlatformMetrics.Pods.Max_Replicas)
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: $($baseline.PlatformMetrics.Pods.Target_CPU_Utilization)
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
$(if ($ApplicationType -eq "web-api") {@"
  - type: Pods
    pods:
      metric:
        name: http_requests_per_second
      target:
        type: AverageValue
        averageValue: "100"
"@})
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 10
        periodSeconds: 60
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
      - type: Percent
        value: 100
        periodSeconds: 30
      - type: Pods
        value: 2
        periodSeconds: 60
"@
    
    $baseline.Configurations = @{
        HPA = $hpaConfig
    }
}

# Generate monitoring alerts
if ($GenerateAlerts) {
    Write-Host "`nGenerating alert configurations..." -ForegroundColor Yellow
    
    # Response time alerts
    $baseline.Alerts += @{
        Name = "High Response Time"
        Condition = "p95_response_time > $($baseline.Metrics.ResponseTime.Target_P95)ms"
        Duration = "5m"
        Severity = "warning"
        Actions = @("notify-slack", "page-oncall")
    }
    
    $baseline.Alerts += @{
        Name = "Critical Response Time"
        Condition = "p99_response_time > $($baseline.Metrics.ResponseTime.Target_P99 * 2)ms"
        Duration = "2m"
        Severity = "critical"
        Actions = @("page-oncall", "escalate")
    }
    
    # Error rate alerts
    $baseline.Alerts += @{
        Name = "High Error Rate"
        Condition = "error_rate > 1%"
        Duration = "5m"
        Severity = "warning"
    }
    
    $baseline.Alerts += @{
        Name = "Service Down"
        Condition = "up == 0"
        Duration = "1m"
        Severity = "critical"
        Actions = @("page-oncall", "auto-restart")
    }
    
    # Resource alerts
    if ($Platform -eq "kubernetes") {
        $baseline.Alerts += @{
            Name = "Pod CPU Pressure"
            Condition = "container_cpu_usage > 90%"
            Duration = "5m"
            Severity = "warning"
        }
        
        $baseline.Alerts += @{
            Name = "Pod Memory Pressure"
            Condition = "container_memory_usage > 90%"
            Duration = "5m"
            Severity = "warning"
        }
        
        $baseline.Alerts += @{
            Name = "Pod Restart Loop"
            Condition = "pod_restart_count > 5"
            Duration = "10m"
            Severity = "critical"
        }
    }
    
    # Generate Prometheus alert rules
    $prometheusAlerts = @"
groups:
  - name: ${ApplicationType}_alerts
    interval: 30s
    rules:
"@
    
    foreach ($alert in $baseline.Alerts) {
        $prometheusAlerts += @"

      - alert: $($alert.Name.Replace(' ', '_'))
        expr: $($alert.Condition)
        for: $($alert.Duration)
        labels:
          severity: $($alert.Severity)
          service: ${ApplicationType}
        annotations:
          summary: "$($alert.Name) detected"
          description: "{{ `$labels.instance }} has triggered $($alert.Name)"
"@
    }
    
    $alertPath = "prometheus-alerts-$(Get-Date -Format 'yyyyMMdd').yaml"
    $prometheusAlerts | Out-File -FilePath $alertPath -Encoding UTF8
    Write-Host "✓ Prometheus alerts saved to: $alertPath" -ForegroundColor Green
}

# Generate dashboard configuration
if ($GenerateDashboard) {
    Write-Host "`nGenerating dashboard configuration..." -ForegroundColor Yellow
    
    $dashboard = @{
        Title = "$ApplicationType Performance Dashboard"
        Panels = @(
            @{
                Title = "Request Rate"
                Type = "graph"
                Query = "rate(http_requests_total[5m])"
                Unit = "req/s"
            }
            @{
                Title = "Response Time (P50, P95, P99)"
                Type = "graph"
                Queries = @(
                    "histogram_quantile(0.5, http_request_duration_seconds)"
                    "histogram_quantile(0.95, http_request_duration_seconds)"
                    "histogram_quantile(0.99, http_request_duration_seconds)"
                )
                Unit = "ms"
            }
            @{
                Title = "Error Rate"
                Type = "graph"
                Query = "rate(http_requests_total{status=~'5..'}[5m])"
                Unit = "%"
                Threshold = 1
            }
            @{
                Title = "Active Users"
                Type = "stat"
                Query = "active_users"
            }
        )
    }
    
    if ($Platform -eq "kubernetes") {
        $dashboard.Panels += @(
            @{
                Title = "Pod Count"
                Type = "graph"
                Query = "kube_deployment_status_replicas{deployment='$ApplicationType'}"
            }
            @{
                Title = "CPU Usage"
                Type = "graph"
                Query = "rate(container_cpu_usage_seconds_total{pod=~'$ApplicationType.*'}[5m])"
                Unit = "cores"
            }
            @{
                Title = "Memory Usage"
                Type = "graph"
                Query = "container_memory_usage_bytes{pod=~'$ApplicationType.*'}"
                Unit = "bytes"
            }
        )
    }
    
    $baseline.Dashboards += $dashboard
    
    # Save as Grafana JSON (simplified)
    $grafanaPath = "grafana-dashboard-$(Get-Date -Format 'yyyyMMdd').json"
    $dashboard | ConvertTo-Json -Depth 10 | Out-File -FilePath $grafanaPath -Encoding UTF8
    Write-Host "✓ Grafana dashboard saved to: $grafanaPath" -ForegroundColor Green
}

# Generate load test scenarios
if ($LoadTest) {
    Write-Host "`nGenerating load test scenarios..." -ForegroundColor Yellow
    
    $scenarios = @()
    
    # Baseline test
    $scenarios += @{
        Name = "Baseline Load"
        Duration = "10m"
        VirtualUsers = [int]($baseline.Metrics.Throughput.ConcurrentUsers * 0.5)
        RampUp = "1m"
        Description = "Normal expected load"
    }
    
    # Peak load test
    $scenarios += @{
        Name = "Peak Load"
        Duration = "30m"
        VirtualUsers = $baseline.Metrics.Throughput.ConcurrentUsers
        RampUp = "5m"
        Description = "Expected peak load"
    }
    
    # Stress test
    $scenarios += @{
        Name = "Stress Test"
        Duration = "15m"
        VirtualUsers = [int]($baseline.Metrics.Throughput.ConcurrentUsers * 1.5)
        RampUp = "3m"
        Description = "150% of expected peak"
    }
    
    # Spike test
    $scenarios += @{
        Name = "Spike Test"
        Duration = "5m"
        VirtualUsers = [int]($baseline.Metrics.Throughput.ConcurrentUsers * 2)
        RampUp = "10s"
        Description = "Sudden traffic spike"
    }
    
    $baseline.LoadTestScenarios = $scenarios
    
    # Generate k6 load test script
    $k6Script = @"
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

const errorRate = new Rate('errors');

export let options = {
  scenarios: {
"@
    
    foreach ($scenario in $scenarios) {
        $k6Script += @"
    $($scenario.Name.ToLower().Replace(' ', '_')): {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '$($scenario.RampUp)', target: $($scenario.VirtualUsers) },
        { duration: '$($scenario.Duration)', target: $($scenario.VirtualUsers) },
        { duration: '1m', target: 0 },
      ],
      gracefulRampDown: '30s',
    },
"@
    }
    
    $k6Script += @"
  },
  thresholds: {
    'http_req_duration': ['p(95)<$($baseline.Metrics.ResponseTime.Target_P95)'],
    'http_req_duration': ['p(99)<$($baseline.Metrics.ResponseTime.Target_P99)'],
    'errors': ['rate<0.01'],
  },
};

export default function() {
  const res = http.get('${BASE_URL}/api/health');
  
  const success = check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
  
  errorRate.add(!success);
  
  sleep(1);
}
"@
    
    $k6Path = "k6-load-test-$(Get-Date -Format 'yyyyMMdd').js"
    $k6Script | Out-File -FilePath $k6Path -Encoding UTF8
    Write-Host "✓ k6 load test script saved to: $k6Path" -ForegroundColor Green
}

# Summary report
Write-Host "`n📊 Performance Baseline Summary" -ForegroundColor Green
Write-Host "==============================" -ForegroundColor Green
Write-Host "Application Type: $ApplicationType" -ForegroundColor White
Write-Host "Platform: $Platform" -ForegroundColor White

Write-Host "`nResponse Time Targets:" -ForegroundColor Yellow
Write-Host "  P50: $($baseline.Metrics.ResponseTime.Target_P50)ms" -ForegroundColor White
Write-Host "  P95: $($baseline.Metrics.ResponseTime.Target_P95)ms" -ForegroundColor White
Write-Host "  P99: $($baseline.Metrics.ResponseTime.Target_P99)ms" -ForegroundColor White

Write-Host "`nThroughput Targets:" -ForegroundColor Yellow
if ($ApplicationType -eq "web-api" -or $ApplicationType -eq "microservices") {
    Write-Host "  RPS: $($baseline.Metrics.Throughput.RequestsPerSecond)" -ForegroundColor White
    Write-Host "  Concurrent Users: $($baseline.Metrics.Throughput.ConcurrentUsers)" -ForegroundColor White
}

Write-Host "`nSLOs Defined:" -ForegroundColor Yellow
$baseline.SLOs | ForEach-Object {
    Write-Host "  • $($_.Name): $($_.Target)" -ForegroundColor White
}

if ($baseline.Alerts.Count -gt 0) {
    Write-Host "`nAlerts Configured: $($baseline.Alerts.Count)" -ForegroundColor Yellow
}

if ($baseline.LoadTestScenarios.Count -gt 0) {
    Write-Host "`nLoad Test Scenarios:" -ForegroundColor Yellow
    $baseline.LoadTestScenarios | ForEach-Object {
        Write-Host "  • $($_.Name): $($_.VirtualUsers) users for $($_.Duration)" -ForegroundColor White
    }
}

# Save complete baseline
$baselinePath = "performance-baseline-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
$baseline | ConvertTo-Json -Depth 10 | Out-File -FilePath $baselinePath -Encoding UTF8
Write-Host "`n📄 Complete baseline saved to: $baselinePath" -ForegroundColor Gray

Write-Host "`n✨ Performance baseline generation complete!" -ForegroundColor Green

# Return baseline for automation
return $baseline
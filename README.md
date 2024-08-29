## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.64.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.64.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | ./modules/terraform-aws-acm | n/a |

## Module usage
### Gateway route
### Resources
````terraform
module "app_mesh" {
  source            = "."
  mesh              = var.mesh
  virtual_gateway   = var.virtual_gateway
  virtual_node      = var.virtual_node
  virtual_service   = var.virtual_service
  gateway_route     = var.gateway_route
}
````
### Vars
````terraform
variable "mesh" {
  type = any
}

variable "virtual_gateway" {
  type = any
}

variable "virtual_node" {
  type = any
}

variable "virtual_service" {
  type = any
}

variable "gateway_route" {
  type = any
}

````
### tfvars
````terraform
mesh = [
  {
    id    = 0
    name  = "simpleapp"
    spec = [
      {
        egress_filter = [
          {
            type = "ALLOW_ALL"
          }
        ]
      }
    ]
  }
]
virtual_gateway = [
  {
    id        = 0
    name      = "example-virtual-gateway"
    mesh_name = "example-service-mesh"
    spec = [
      {
        listener = [
          {
            port_mapping = [
              {
                  port = 8080
                  protocol = "http"
              }
            ]
          }
        ]
      }
    ]
    tags = {
      Environment = "test"
    }
  }
]
virtual_node = [
  {
    id        = 0
    name      = "serviceBv1"
    mesh_id   = 0
    spec = [
      {
          backend = [
            {
              virtual_service = [
                {
                  virtual_service_name = "servicea.simpleapp.local"
                }
              ]
            }
          ]
    
          listener = [
            {
              port_mapping = [
                {
                  port     = 8080
                  protocol = "http"
                }
              ]
            }
          ]
    
          service_discovery = [
            {
              dns = [
                {
                  hostname = "serviceb.simpleapp.local"
                }
              ]
            }
          ]
      } 
    ]
  }
]
virtual_service = [
  {
    id        = 0
    name      = "servicea.simpleapp.local"
    mesh_id   = 0
    spec = [
      {
        provider = [
            {
              virtual_node = [
                {
                  virtual_node_id = 0
                }
              ]
          }
        ]
      }
    ]
  }
]
gateway_route = [
  {
    id                   = 0
    name                 = "example-gateway-route"
    mesh_id              = 0
    virtual_gateway_id   = 0
    spec = [
      {
        http = [
          {
            action = [
              {
                target = [
                  {
                    virtual_service = [
                      {
                        virtual_service_id = 0
                      }
                    ]
                  }
                ]
              }
            ]
            match = [
              {
                prefix = "/"
              }
            ]
          }
        ]
      }
    ]
  }
]
````

## Resources

| Name | Type |
|------|------|
| [aws_appmesh_gateway_route.this](https://registry.terraform.io/providers/hashicorp/aws/5.64.0/docs/resources/appmesh_gateway_route) | resource |
| [aws_appmesh_mesh.this](https://registry.terraform.io/providers/hashicorp/aws/5.64.0/docs/resources/appmesh_mesh) | resource |
| [aws_appmesh_route.this](https://registry.terraform.io/providers/hashicorp/aws/5.64.0/docs/resources/appmesh_route) | resource |
| [aws_appmesh_virtual_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/5.64.0/docs/resources/appmesh_virtual_gateway) | resource |
| [aws_appmesh_virtual_node.this](https://registry.terraform.io/providers/hashicorp/aws/5.64.0/docs/resources/appmesh_virtual_node) | resource |
| [aws_appmesh_virtual_router.this](https://registry.terraform.io/providers/hashicorp/aws/5.64.0/docs/resources/appmesh_virtual_router) | resource |
| [aws_appmesh_virtual_service.this](https://registry.terraform.io/providers/hashicorp/aws/5.64.0/docs/resources/appmesh_virtual_service) | resource |
| [aws_default_tags.this](https://registry.terraform.io/providers/hashicorp/aws/5.64.0/docs/data-sources/default_tags) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acmpca_certificate"></a> [acmpca\_certificate](#input\_acmpca\_certificate) | n/a | `any` | n/a | yes |
| <a name="input_acmpca_certificate_authority"></a> [acmpca\_certificate\_authority](#input\_acmpca\_certificate\_authority) | n/a | `any` | n/a | yes |
| <a name="input_acmpca_certificate_authority_certificate"></a> [acmpca\_certificate\_authority\_certificate](#input\_acmpca\_certificate\_authority\_certificate) | n/a | `any` | n/a | yes |
| <a name="input_gateway_route"></a> [gateway\_route](#input\_gateway\_route) | n/a | <pre>list(object({<br>    id                 = number<br>    mesh_id            = any<br>    name               = string<br>    virtual_gateway_id = any<br>    mesh_owner         = optional(string)<br>    tags               = optional(map(string))<br>    spec = list(object({<br>      grpc_route = optional(list(object({<br>        action = list(object({<br>          target = list(object({<br>            port = number<br>            virtual_service = list(object({<br>              virtual_service_name = string<br>            }))<br>          }))<br>        }))<br>        match = list(object({<br>          service_name = string<br>          port         = optional(number)<br>        }))<br>      })))<br>      http_route = optional(list(object({<br>        action = list(object({<br>          target = list(object({<br>            port = number<br>            virtual_service = list(object({<br>              virtual_service_name = string<br>            }))<br>          }))<br>          rewrite = optional(list(object({<br>            hostname = optional(list(object({<br>              default_target_hostname = string<br>            })))<br>            path = optional(list(object({<br>              exact = string<br>            })))<br>            prefix = optional(list(object({<br>              default_prefix = optional(string)<br>              value          = optional(string)<br>            })))<br>          })))<br>        }))<br>        match = list(object({<br>          port   = optional(number)<br>          prefix = optional(string)<br>          header = optional(list(object({<br>            name   = string<br>            invert = optional(bool)<br>            match = optional(list(object({<br>              exact  = optional(string)<br>              prefix = optional(string)<br>              port   = optional(number)<br>              regex  = optional(string)<br>              suffix = optional(string)<br>              range = optional(list(object({<br>                end   = number<br>                start = number<br>              })))<br>            })))<br>          })))<br>          hostname = optional(list(object({<br>            exact  = optional(string)<br>            suffix = optional(string)<br>          })))<br>          path = optional(list(object({<br>            exact = optional(string)<br>            regex = optional(string)<br>          })))<br>          query_parameter = optional(list(object({<br>            name = string<br>            match = optional(list(object({<br>              exact = optional(string)<br>            })))<br>          })))<br>        }))<br>      })))<br>      http2_route = optional(list(object({<br>        action = list(object({<br>          target = list(object({<br>            port = number<br>            virtual_service = list(object({<br>              virtual_service_name = string<br>            }))<br>          }))<br>          rewrite = optional(list(object({<br>            host = optional(list(object({<br>              default_target_hostname = string<br>            })))<br>            path = optional(list(object({<br>              exact = string<br>            })))<br>            prefix = optional(list(object({<br>              default_prefix = optional(string)<br>              value          = optional(string)<br>            })))<br>          })))<br>        }))<br>        match = list(object({<br>          port   = optional(number)<br>          prefix = optional(string)<br>          header = optional(list(object({<br>            name   = string<br>            invert = optional(bool)<br>            match = optional(list(object({<br>              exact  = optional(string)<br>              prefix = optional(string)<br>              port   = optional(number)<br>              regex  = optional(string)<br>              suffix = optional(string)<br>              range = optional(list(object({<br>                end   = number<br>                start = number<br>              })))<br>            })))<br>          })))<br>          hostname = optional(list(object({<br>            exact  = optional(string)<br>            suffix = optional(string)<br>          })))<br>          path = optional(list(object({<br>            exact = optional(string)<br>            regex = optional(string)<br>          })))<br>          query_parameter = optional(list(object({<br>            name = string<br>            match = optional(list(object({<br>              exact = optional(string)<br>            })))<br>          })))<br>        }))<br>      })))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_mesh"></a> [mesh](#input\_mesh) | n/a | <pre>list(object({<br>    id   = number<br>    name = string<br>    tags = optional(map(string))<br>    spec = optional(list(object({<br>      egress_filter = optional(list(object({<br>        type = optional(string)<br>      })))<br>      service_discovery = optional(list(object({<br>        ip_preference = optional(string)<br>      })))<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_route"></a> [route](#input\_route) | n/a | <pre>list(object({<br>    id                = number<br>    mesh_id           = any<br>    name              = string<br>    virtual_router_id = any<br>    spec = list(object({<br>      priority = optional(number)<br>      grpc_route = optional(list(object({<br>        action = list(object({<br>          weighted_target = list(object({<br>            virtual_node = string<br>            weigth       = number<br>            port         = optional(number)<br>          }))<br>        }))<br>        match = list(object({<br>          method_name  = optional(string)<br>          service_name = optional(string)<br>          port         = optional(number)<br>          metadata = optional(list(object({<br>            name   = string<br>            invert = optional(bool)<br>            match = optional(list(object({<br>              exact  = optional(string)<br>              prefix = optional(string)<br>              port   = optional(number)<br>              regex  = optional(string)<br>              suffix = optional(string)<br>              range = optional(list(object({<br>                end   = number<br>                start = number<br>              })))<br>            })))<br>          })))<br>        }))<br>        retry_policy = list(object({<br>          max_retries       = number<br>          grpc_retry_events = optional(list(string))<br>          http_retry_events = optional(list(string))<br>          tcp_retry_events  = optional(list(string))<br>          per_retry_timeout = list(object({<br>            unit  = string<br>            value = number<br>          }))<br>        }))<br>        timeout = optional(list(object({<br>          idle = optional(list(object({<br>            unit  = string<br>            value = number<br>          })))<br>        })))<br>      })))<br>      http_route = optional(list(object({<br>        action = list(object({<br>          weighted_target = list(object({<br>            virtual_node = string<br>            weigth       = number<br>            port         = optional(number)<br>          }))<br>        }))<br>        match = list(object({<br>          prefix = optional(string)<br>          port   = optional(number)<br>          method = optional(string)<br>          header = optional(list(object({<br>            name = string<br>          })))<br>          path = optional(list(object({<br>            exact = optional(string)<br>            regex = optional(string)<br>          })))<br>          query_parameter = optional(list(object({<br>            name = string<br>            match = optional(list(object({<br>              exact = optional(string)<br>            })))<br>          })))<br>        }))<br>        retry_policy = list(object({<br>          max_retries       = number<br>          http_retry_events = optional(list(string))<br>          tcp_retry_events  = optional(list(string))<br>          per_retry_timeout = list(object({<br>            unit  = string<br>            value = number<br>          }))<br>        }))<br>        timeout = optional(list(object({<br>          idle = optional(list(object({<br>            unit  = string<br>            value = number<br>          })))<br>          per_request = optional(list(object({<br>            unit  = string<br>            value = number<br>          })))<br>        })))<br>      })))<br>      http2_route = optional(list(object({<br>        action = list(object({<br>          weighted_target = list(object({<br>            virtual_node = string<br>            weigth       = number<br>            port         = optional(number)<br>          }))<br>        }))<br>        match = list(object({<br>          prefix = optional(string)<br>          port   = optional(number)<br>          header = optional(list(object({<br>            name = string<br>          })))<br>          method = optional(string)<br>          path = optional(list(object({<br>            exact = optional(string)<br>            regex = optional(string)<br>          })))<br>          query_parameter = optional(list(object({<br>            name = string<br>            match = optional(list(object({<br>              exact = optional(string)<br>            })))<br>          })))<br>        }))<br>        retry_policy = list(object({<br>          max_retries       = number<br>          http_retry_events = optional(list(string))<br>          tcp_retry_events  = optional(list(string))<br>          per_retry_timeout = list(object({<br>            unit  = string<br>            value = number<br>          }))<br>        }))<br>        timeout = optional(list(object({<br>          idle = optional(list(object({<br>            unit  = string<br>            value = number<br>          })))<br>          per_request = optional(list(object({<br>            unit  = string<br>            value = number<br>          })))<br>        })))<br>      })))<br>      tcp_route = optional(list(object({<br>        action = list(object({<br>          weighted_target = list(object({<br>            virtual_node = string<br>            weigth       = number<br>            port         = optional(number)<br>          }))<br>        }))<br>        match = list(object({<br>          port = optional(number)<br>        }))<br>        timeout = optional(list(object({<br>          idle = optional(list(object({<br>            unit  = string<br>            value = number<br>          })))<br>        })))<br>      })))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_virtual_gateway"></a> [virtual\_gateway](#input\_virtual\_gateway) | n/a | <pre>list(object({<br>    id         = number<br>    mesh_id    = any<br>    name       = string<br>    mesh_owner = optional(string)<br>    tags       = optional(map(string))<br>    spec = list(object({<br>      listener = list(object({<br>        port_mapping = list(object({<br>          port     = number<br>          protocol = string<br>        }))<br>        connection_pool = optional(list(object({<br>          grpc = optional(list(object({<br>            max_requests = number<br>          })))<br>          http = optional(list(object({<br>            max_connections      = number<br>            max_pending_requests = optional(number)<br>          })))<br>          http2 = optional(list(object({<br>            max_requests = number<br>          })))<br>        })))<br>        health_check = optional(list(object({<br>          healthy_threshold   = number<br>          interval_millis     = number<br>          protocol            = string<br>          timeout_millis      = number<br>          unhealthy_threshold = number<br>          path                = optional(string)<br>          port                = optional(number)<br>        })))<br>        tls = optional(list(object({<br>          mode = string<br>          certificate = list(object({<br>            acm = optional(list(object({<br>              certificate_id = any<br>            })))<br>            file = optional(list(object({<br>              certificate_chain = string<br>              private_key       = string<br>            })))<br>            sds = optional(list(object({<br>              secret_name = string<br>            })))<br>          }))<br>          validation = optional(list(object({<br>            subject_alternative_names = optional(list(object({<br>              match = list(object({<br>                exact = list(any)<br>              }))<br>            })))<br>            trust = list(object({<br>              file = optional(list(object({<br>                certificate_chain = string<br>              })))<br>              sds = optional(list(object({<br>                secret_name = string<br>              })))<br>            }))<br>          })))<br>        })))<br>      }))<br>      logging = optional(list(object({<br>        access_log = optional(list(object({<br>          file = optional(list(object({<br>            path = string<br>            format = optional(list(object({<br>              text = optional(string)<br>              json = optional(list(object({<br>                key   = string<br>                value = string<br>              })))<br>            })))<br>          })))<br>        })))<br>      })))<br>      backend_defaults = optional(list(object({<br>        client_policy = optional(list(object({<br>          tls = optional(list(object({<br>            enforce = optional(bool)<br>            ports   = optional(list(any))<br>            certificate = optional(list(object({<br>              file = optional(list(object({<br>                certificate_chain = string<br>                private_key       = string<br>              })))<br>              sds = optional(list(object({<br>                secret_name = string<br>              })))<br>            })))<br>            validation = list(object({<br>              subject_alternative_names = optional(list(object({<br>                match = list(object({<br>                  exact = list(any)<br>                }))<br>              })))<br>              trust = list(object({<br>                acm = optional(list(object({<br>                  certificate_authority_id = any<br>                })))<br>                file = optional(list(object({<br>                  certificate_chain = string<br>                })))<br>                sds = optional(list(object({<br>                  secret_name = string<br>                })))<br>              }))<br>            }))<br>          })))<br>        })))<br>      })))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_virtual_node"></a> [virtual\_node](#input\_virtual\_node) | n/a | <pre>list(object({<br>    id         = number<br>    mesh_id    = any<br>    name       = string<br>    mesh_owner = optional(string)<br>    tags       = optional(map(string))<br>    spec = list(object({<br>      backend = optional(list(object({<br>        virtual_service = list(object({<br>          virtual_service_name = string<br>          client_policy = optional(list(object({<br>            tls = optional(list(object({<br>              enforce = optional(bool)<br>              ports   = optional(list(any))<br>              certificate = optional(list(object({<br>                file = optional(list(object({<br>                  certificate_chain = string<br>                  private_key       = string<br>                })))<br>                sds = optional(list(object({<br>                  secret_name = string<br>                })))<br>              })))<br>              validation = list(object({<br>                subject_alternative_names = optional(list(object({<br>                  match = list(object({<br>                    exact = list(any)<br>                  }))<br>                })))<br>                trust = list(object({<br>                  acm = optional(list(object({<br>                    certificate_authority_id = any<br>                  })))<br>                  file = optional(list(object({<br>                    certificate_chain = string<br>                  })))<br>                  sds = optional(list(object({<br>                    secret_name = string<br>                  })))<br>                }))<br>              }))<br>            })))<br>          })))<br>        }))<br>      })))<br>      backend_defaults = optional(list(object({<br>        client_policy = optional(list(object({<br>          tls = optional(list(object({<br>            enforce = optional(bool)<br>            ports   = optional(list(any))<br>            certificate = optional(list(object({<br>              file = optional(list(object({<br>                certificate_chain = string<br>                private_key       = string<br>              })))<br>              sds = optional(list(object({<br>                secret_name = string<br>              })))<br>            })))<br>            validation = list(object({<br>              subject_alternative_names = optional(list(object({<br>                match = list(object({<br>                  exact = list(any)<br>                }))<br>              })))<br>              trust = list(object({<br>                acm = optional(list(object({<br>                  certificate_authority_id = any<br>                })))<br>                file = optional(list(object({<br>                  certificate_chain = string<br>                })))<br>                sds = optional(list(object({<br>                  secret_name = string<br>                })))<br>              }))<br>            }))<br>          })))<br>        })))<br>      })))<br>      listener = optional(list(object({<br>        connection_pool = optional(list(object({<br>          grpc = optional(list(object({<br>            max_requests = number<br>          })))<br>          http = optional(list(object({<br>            max_connections      = number<br>            max_pending_requests = optional(number)<br>          })))<br>          http2 = optional(list(object({<br>            max_requests = number<br>          })))<br>          tcp = optional(list(object({<br>            max_connections = number<br>          })))<br>        })))<br>        health_check = optional(list(object({<br>          healthy_threshold   = string<br>          interval_millis     = number<br>          protocol            = string<br>          timeout_millis      = number<br>          unhealthy_threshold = string<br>          path                = optional(string)<br>          port                = optional(number)<br>        })))<br>        outlier_detection = optional(list(object({<br>          max_ejection_percent = number<br>          max_server_errors    = number<br>          base_ejection_duration = list(object({<br>            unit  = string<br>            value = number<br>          }))<br>          interval = list(object({<br>            unit  = string<br>            value = number<br>          }))<br>        })))<br>        port_mapping = list(object({<br>          port     = number<br>          protocol = string<br>        }))<br>        timeout = optional(list(object({<br>          grpc = optional(list(object({<br>            idle = optional(list(object({<br>              unit  = string<br>              value = number<br>            })))<br>            per_request = optional(list(object({<br>              unit  = string<br>              value = number<br>            })))<br>          })))<br>          http = optional(list(object({<br>            idle = optional(list(object({<br>              unit  = string<br>              value = number<br>            })))<br>            per_request = optional(list(object({<br>              unit  = string<br>              value = number<br>            })))<br>          })))<br>          http2 = optional(list(object({<br>            idle = optional(list(object({<br>              unit  = string<br>              value = number<br>            })))<br>            per_request = optional(list(object({<br>              unit  = string<br>              value = number<br>            })))<br>          })))<br>          tcp = optional(list(object({<br>            idle = optional(list(object({<br>              unit  = string<br>              value = number<br>            })))<br>            per_request = optional(list(object({<br>              unit  = string<br>              value = number<br>            })))<br>          })))<br>        })))<br>        tls = optional(list(object({<br>          mode = string<br>          certificate = optional(list(object({<br>            file = optional(list(object({<br>              certificate_chain = string<br>              private_key       = string<br>            })))<br>            sds = optional(list(object({<br>              secret_name = string<br>            })))<br>          })))<br>          validation = list(object({<br>            subject_alternative_names = optional(list(object({<br>              match = list(object({<br>                exact = list(any)<br>              }))<br>            })))<br>            trust = list(object({<br>              acm = optional(list(object({<br>                certificate_authority_id = any<br>              })))<br>              file = optional(list(object({<br>                certificate_chain = string<br>              })))<br>              sds = optional(list(object({<br>                secret_name = string<br>              })))<br>            }))<br>          }))<br>        })))<br>      })))<br>      logging = optional(list(object({<br>        access_log = optional(list(object({<br>          file = optional(list(object({<br>            path = string<br>            format = optional(list(object({<br>              text = optional(string)<br>              json = optional(list(object({<br>                key   = string<br>                value = string<br>              })))<br>            })))<br>          })))<br>        })))<br>      })))<br>      service_discovery = optional(list(object({<br>        aws_cloud_map = optional(list(object({<br>          namespace_name = string<br>          service_name   = optional(string)<br>          attributes     = optional(map(string))<br>        })))<br>        dns = optional(list(object({<br>          hostname      = string<br>          ip_preference = optional(string)<br>          response_type = optional(string)<br>        })))<br>      })))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_virtual_router"></a> [virtual\_router](#input\_virtual\_router) | n/a | <pre>list(object({<br>    id         = number<br>    mesh_id    = any<br>    name       = string<br>    mesh_owner = optional(string)<br>    tags       = optional(map(string))<br>    spec = list(object({<br>      listener = optional(list(object({<br>        port_mapping = list(object({<br>          port     = number<br>          protocol = string<br>        }))<br>      })))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_virtual_service"></a> [virtual\_service](#input\_virtual\_service) | n/a | <pre>list(object({<br>    id         = number<br>    mesh_id    = any<br>    name       = string<br>    mesh_owner = optional(string)<br>    tags       = optional(map(string))<br>    spec       = list(object({<br>      provider = optional(list(object({<br>        virtual_node = optional(list(object({<br>          virtual_node_id = any<br>        })))<br>        virtual_router = optional(list(object({<br>          virtual_router_id = any<br>        })))<br>      })))<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gateway_route_arn"></a> [gateway\_route\_arn](#output\_gateway\_route\_arn) | n/a |
| <a name="output_gateway_route_id"></a> [gateway\_route\_id](#output\_gateway\_route\_id) | n/a |
| <a name="output_gateway_route_name"></a> [gateway\_route\_name](#output\_gateway\_route\_name) | n/a |
| <a name="output_mesh_arn"></a> [mesh\_arn](#output\_mesh\_arn) | n/a |
| <a name="output_mesh_id"></a> [mesh\_id](#output\_mesh\_id) | n/a |
| <a name="output_mesh_name"></a> [mesh\_name](#output\_mesh\_name) | n/a |
| <a name="output_route_arn"></a> [route\_arn](#output\_route\_arn) | n/a |
| <a name="output_route_id"></a> [route\_id](#output\_route\_id) | n/a |
| <a name="output_route_name"></a> [route\_name](#output\_route\_name) | n/a |
| <a name="output_virtual_gateway_arn"></a> [virtual\_gateway\_arn](#output\_virtual\_gateway\_arn) | n/a |
| <a name="output_virtual_gateway_id"></a> [virtual\_gateway\_id](#output\_virtual\_gateway\_id) | n/a |
| <a name="output_virtual_gateway_name"></a> [virtual\_gateway\_name](#output\_virtual\_gateway\_name) | n/a |
| <a name="output_virtual_node_arn"></a> [virtual\_node\_arn](#output\_virtual\_node\_arn) | n/a |
| <a name="output_virtual_node_id"></a> [virtual\_node\_id](#output\_virtual\_node\_id) | n/a |
| <a name="output_virtual_node_name"></a> [virtual\_node\_name](#output\_virtual\_node\_name) | n/a |
| <a name="output_virtual_router_arn"></a> [virtual\_router\_arn](#output\_virtual\_router\_arn) | n/a |
| <a name="output_virtual_router_id"></a> [virtual\_router\_id](#output\_virtual\_router\_id) | n/a |
| <a name="output_virtual_router_name"></a> [virtual\_router\_name](#output\_virtual\_router\_name) | n/a |
| <a name="output_virtual_service_arn"></a> [virtual\_service\_arn](#output\_virtual\_service\_arn) | n/a |
| <a name="output_virtual_service_id"></a> [virtual\_service\_id](#output\_virtual\_service\_id) | n/a |
| <a name="output_virtual_service_name"></a> [virtual\_service\_name](#output\_virtual\_service\_name) | n/a |

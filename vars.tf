## TAGS

variable "tags" {
  type    = map(string)
  default = {}
}

## MODULES

variable "acmpca_certificate_authority" {
  type = any
}

variable "acmpca_certificate" {
  type = any
}

variable "acmpca_certificate_authority_certificate" {
  type = any
}

## RESOURCES

variable "gateway_route" {
  type = list(object({
    id                 = number
    mesh_id            = any
    name               = string
    virtual_gateway_id = any
    mesh_owner         = optional(string)
    tags               = optional(map(string))
    spec = list(object({
      grpc_route = optional(list(object({
        action = list(object({
          target = list(object({
            port = number
            virtual_service = list(object({
              virtual_service_name = string
            }))
          }))
        }))
        match = list(object({
          service_name = string
          port         = optional(number)
        }))
      })))
      http_route = optional(list(object({
        action = list(object({
          target = list(object({
            port = number
            virtual_service = list(object({
              virtual_service_name = string
            }))
          }))
          rewrite = optional(list(object({
            hostname = optional(list(object({
              default_target_hostname = string
            })))
            path = optional(list(object({
              exact = string
            })))
            prefix = optional(list(object({
              default_prefix = optional(string)
              value          = optional(string)
            })))
          })))
        }))
        match = list(object({
          port   = optional(number)
          prefix = optional(string)
          header = optional(list(object({
            name   = string
            invert = optional(bool)
            match = optional(list(object({
              exact  = optional(string)
              prefix = optional(string)
              port   = optional(number)
              regex  = optional(string)
              suffix = optional(string)
              range = optional(list(object({
                end   = number
                start = number
              })))
            })))
          })))
          hostname = optional(list(object({
            exact  = optional(string)
            suffix = optional(string)
          })))
          path = optional(list(object({
            exact = optional(string)
            regex = optional(string)
          })))
          query_parameter = optional(list(object({
            name = string
            match = optional(list(object({
              exact = optional(string)
            })))
          })))
        }))
      })))
      http2_route = optional(list(object({
        action = list(object({
          target = list(object({
            port = number
            virtual_service = list(object({
              virtual_service_name = string
            }))
          }))
          rewrite = optional(list(object({
            host = optional(list(object({
              default_target_hostname = string
            })))
            path = optional(list(object({
              exact = string
            })))
            prefix = optional(list(object({
              default_prefix = optional(string)
              value          = optional(string)
            })))
          })))
        }))
        match = list(object({
          port   = optional(number)
          prefix = optional(string)
          header = optional(list(object({
            name   = string
            invert = optional(bool)
            match = optional(list(object({
              exact  = optional(string)
              prefix = optional(string)
              port   = optional(number)
              regex  = optional(string)
              suffix = optional(string)
              range = optional(list(object({
                end   = number
                start = number
              })))
            })))
          })))
          hostname = optional(list(object({
            exact  = optional(string)
            suffix = optional(string)
          })))
          path = optional(list(object({
            exact = optional(string)
            regex = optional(string)
          })))
          query_parameter = optional(list(object({
            name = string
            match = optional(list(object({
              exact = optional(string)
            })))
          })))
        }))
      })))
    }))
  }))
  default = []
}

variable "mesh" {
  type = list(object({
    id   = number
    name = string
    tags = optional(map(string))
    spec = optional(list(object({
      egress_filter = optional(list(object({
        type = optional(string)
      })))
      service_discovery = optional(list(object({
        ip_preference = optional(string)
      })))
    })))
  }))
  default = []
}

variable "route" {
  type = list(object({
    id                = number
    mesh_id           = any
    name              = string
    virtual_router_id = any
    spec = list(object({
      priority = optional(number)
      grpc_route = optional(list(object({
        action = list(object({
          weighted_target = list(object({
            virtual_node = string
            weigth       = number
            port         = optional(number)
          }))
        }))
        match = list(object({
          method_name  = optional(string)
          service_name = optional(string)
          port         = optional(number)
          metadata = optional(list(object({
            name   = string
            invert = optional(bool)
            match = optional(list(object({
              exact  = optional(string)
              prefix = optional(string)
              port   = optional(number)
              regex  = optional(string)
              suffix = optional(string)
              range = optional(list(object({
                end   = number
                start = number
              })))
            })))
          })))
        }))
        retry_policy = list(object({
          max_retries       = number
          grpc_retry_events = optional(list(string))
          http_retry_events = optional(list(string))
          tcp_retry_events  = optional(list(string))
          per_retry_timeout = list(object({
            unit  = string
            value = number
          }))
        }))
        timeout = optional(list(object({
          idle = optional(list(object({
            unit  = string
            value = number
          })))
        })))
      })))
      http_route = optional(list(object({
        action = list(object({
          weighted_target = list(object({
            virtual_node = string
            weigth       = number
            port         = optional(number)
          }))
        }))
        match = list(object({
          prefix = optional(string)
          port   = optional(number)
          method = optional(string)
          header = optional(list(object({
            name = string
          })))
          path = optional(list(object({
            exact = optional(string)
            regex = optional(string)
          })))
          query_parameter = optional(list(object({
            name = string
            match = optional(list(object({
              exact = optional(string)
            })))
          })))
        }))
        retry_policy = list(object({
          max_retries       = number
          http_retry_events = optional(list(string))
          tcp_retry_events  = optional(list(string))
          per_retry_timeout = list(object({
            unit  = string
            value = number
          }))
        }))
        timeout = optional(list(object({
          idle = optional(list(object({
            unit  = string
            value = number
          })))
          per_request = optional(list(object({
            unit  = string
            value = number
          })))
        })))
      })))
      http2_route = optional(list(object({
        action = list(object({
          weighted_target = list(object({
            virtual_node = string
            weigth       = number
            port         = optional(number)
          }))
        }))
        match = list(object({
          prefix = optional(string)
          port   = optional(number)
          header = optional(list(object({
            name = string
          })))
          method = optional(string)
          path = optional(list(object({
            exact = optional(string)
            regex = optional(string)
          })))
          query_parameter = optional(list(object({
            name = string
            match = optional(list(object({
              exact = optional(string)
            })))
          })))
        }))
        retry_policy = list(object({
          max_retries       = number
          http_retry_events = optional(list(string))
          tcp_retry_events  = optional(list(string))
          per_retry_timeout = list(object({
            unit  = string
            value = number
          }))
        }))
        timeout = optional(list(object({
          idle = optional(list(object({
            unit  = string
            value = number
          })))
          per_request = optional(list(object({
            unit  = string
            value = number
          })))
        })))
      })))
      tcp_route = optional(list(object({
        action = list(object({
          weighted_target = list(object({
            virtual_node = string
            weigth       = number
            port         = optional(number)
          }))
        }))
        match = list(object({
          port = optional(number)
        }))
        timeout = optional(list(object({
          idle = optional(list(object({
            unit  = string
            value = number
          })))
        })))
      })))
    }))
  }))
  default = []
}

variable "virtual_gateway" {
  type = list(object({
    id         = number
    mesh_id    = any
    name       = string
    mesh_owner = optional(string)
    tags       = optional(map(string))
    spec = list(object({
      listener = list(object({
        port_mapping = list(object({
          port     = number
          protocol = string
        }))
        connection_pool = optional(list(object({
          grpc = optional(list(object({
            max_requests = number
          })))
          http = optional(list(object({
            max_connections      = number
            max_pending_requests = optional(number)
          })))
          http2 = optional(list(object({
            max_requests = number
          })))
        })))
        health_check = optional(list(object({
          healthy_threshold   = number
          interval_millis     = number
          protocol            = string
          timeout_millis      = number
          unhealthy_threshold = number
          path                = optional(string)
          port                = optional(number)
        })))
        tls = optional(list(object({
          mode = string
          certificate = list(object({
            acm = optional(list(object({
              certificate_id = any
            })))
            file = optional(list(object({
              certificate_chain = string
              private_key       = string
            })))
            sds = optional(list(object({
              secret_name = string
            })))
          }))
          validation = optional(list(object({
            subject_alternative_names = optional(list(object({
              match = list(object({
                exact = list(any)
              }))
            })))
            trust = list(object({
              file = optional(list(object({
                certificate_chain = string
              })))
              sds = optional(list(object({
                secret_name = string
              })))
            }))
          })))
        })))
      }))
      logging = optional(list(object({
        access_log = optional(list(object({
          file = optional(list(object({
            path = string
            format = optional(list(object({
              text = optional(string)
              json = optional(list(object({
                key   = string
                value = string
              })))
            })))
          })))
        })))
      })))
      backend_defaults = optional(list(object({
        client_policy = optional(list(object({
          tls = optional(list(object({
            enforce = optional(bool)
            ports   = optional(list(any))
            certificate = optional(list(object({
              file = optional(list(object({
                certificate_chain = string
                private_key       = string
              })))
              sds = optional(list(object({
                secret_name = string
              })))
            })))
            validation = list(object({
              subject_alternative_names = optional(list(object({
                match = list(object({
                  exact = list(any)
                }))
              })))
              trust = list(object({
                acm = optional(list(object({
                  certificate_authority_id = any
                })))
                file = optional(list(object({
                  certificate_chain = string
                })))
                sds = optional(list(object({
                  secret_name = string
                })))
              }))
            }))
          })))
        })))
      })))
    }))
  }))
  default = []
}

variable "virtual_node" {
  type = list(object({
    id         = number
    mesh_id    = any
    name       = string
    mesh_owner = optional(string)
    tags       = optional(map(string))
    spec = list(object({
      backend = optional(list(object({
        virtual_service = list(object({
          virtual_service_name = string
          client_policy = optional(list(object({
            tls = optional(list(object({
              enforce = optional(bool)
              ports   = optional(list(any))
              certificate = optional(list(object({
                file = optional(list(object({
                  certificate_chain = string
                  private_key       = string
                })))
                sds = optional(list(object({
                  secret_name = string
                })))
              })))
              validation = list(object({
                subject_alternative_names = optional(list(object({
                  match = list(object({
                    exact = list(any)
                  }))
                })))
                trust = list(object({
                  acm = optional(list(object({
                    certificate_authority_id = any
                  })))
                  file = optional(list(object({
                    certificate_chain = string
                  })))
                  sds = optional(list(object({
                    secret_name = string
                  })))
                }))
              }))
            })))
          })))
        }))
      })))
      backend_defaults = optional(list(object({
        client_policy = optional(list(object({
          tls = optional(list(object({
            enforce = optional(bool)
            ports   = optional(list(any))
            certificate = optional(list(object({
              file = optional(list(object({
                certificate_chain = string
                private_key       = string
              })))
              sds = optional(list(object({
                secret_name = string
              })))
            })))
            validation = list(object({
              subject_alternative_names = optional(list(object({
                match = list(object({
                  exact = list(any)
                }))
              })))
              trust = list(object({
                acm = optional(list(object({
                  certificate_authority_id = any
                })))
                file = optional(list(object({
                  certificate_chain = string
                })))
                sds = optional(list(object({
                  secret_name = string
                })))
              }))
            }))
          })))
        })))
      })))
      listener = optional(list(object({
        connection_pool = optional(list(object({
          grpc = optional(list(object({
            max_requests = number
          })))
          http = optional(list(object({
            max_connections      = number
            max_pending_requests = optional(number)
          })))
          http2 = optional(list(object({
            max_requests = number
          })))
          tcp = optional(list(object({
            max_connections = number
          })))
        })))
        health_check = optional(list(object({
          healthy_threshold   = string
          interval_millis     = number
          protocol            = string
          timeout_millis      = number
          unhealthy_threshold = string
          path                = optional(string)
          port                = optional(number)
        })))
        outlier_detection = optional(list(object({
          max_ejection_percent = number
          max_server_errors    = number
          base_ejection_duration = list(object({
            unit  = string
            value = number
          }))
          interval = list(object({
            unit  = string
            value = number
          }))
        })))
        port_mapping = list(object({
          port     = number
          protocol = string
        }))
        timeout = optional(list(object({
          grpc = optional(list(object({
            idle = optional(list(object({
              unit  = string
              value = number
            })))
            per_request = optional(list(object({
              unit  = string
              value = number
            })))
          })))
          http = optional(list(object({
            idle = optional(list(object({
              unit  = string
              value = number
            })))
            per_request = optional(list(object({
              unit  = string
              value = number
            })))
          })))
          http2 = optional(list(object({
            idle = optional(list(object({
              unit  = string
              value = number
            })))
            per_request = optional(list(object({
              unit  = string
              value = number
            })))
          })))
          tcp = optional(list(object({
            idle = optional(list(object({
              unit  = string
              value = number
            })))
            per_request = optional(list(object({
              unit  = string
              value = number
            })))
          })))
        })))
        tls = optional(list(object({
          mode = string
          certificate = optional(list(object({
            file = optional(list(object({
              certificate_chain = string
              private_key       = string
            })))
            sds = optional(list(object({
              secret_name = string
            })))
          })))
          validation = list(object({
            subject_alternative_names = optional(list(object({
              match = list(object({
                exact = list(any)
              }))
            })))
            trust = list(object({
              acm = optional(list(object({
                certificate_authority_id = any
              })))
              file = optional(list(object({
                certificate_chain = string
              })))
              sds = optional(list(object({
                secret_name = string
              })))
            }))
          }))
        })))
      })))
      logging = optional(list(object({
        access_log = optional(list(object({
          file = optional(list(object({
            path = string
            format = optional(list(object({
              text = optional(string)
              json = optional(list(object({
                key   = string
                value = string
              })))
            })))
          })))
        })))
      })))
      service_discovery = optional(list(object({
        aws_cloud_map = optional(list(object({
          namespace_name = string
          service_name   = optional(string)
          attributes     = optional(map(string))
        })))
        dns = optional(list(object({
          hostname      = string
          ip_preference = optional(string)
          response_type = optional(string)
        })))
      })))
    }))
  }))
  default = []
}

variable "virtual_router" {
  type = list(object({
    id         = number
    mesh_id    = any
    name       = string
    mesh_owner = optional(string)
    tags       = optional(map(string))
    spec = list(object({
      listener = optional(list(object({
        port_mapping = list(object({
          port     = number
          protocol = string
        }))
      })))
    }))
  }))
  default = []
}

variable "virtual_service" {
  type = list(object({
    id         = number
    mesh_id    = any
    name       = string
    mesh_owner = optional(string)
    tags       = optional(map(string))
    spec       = list(object({
      provider = optional(list(object({
        virtual_node = optional(list(object({
          virtual_node_id = any
        })))
        virtual_router = optional(list(object({
          virtual_router_id = any
        })))
      })))
    }))
  }))
  default = []
}
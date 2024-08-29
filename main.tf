resource "aws_appmesh_gateway_route" "this" {
  count                = length(var.mesh) == 0 ? 0 : length(var.gateway_route)
  mesh_name            = try(element(aws_appmesh_mesh.this.*.id, lookup(var.gateway_route[count.index], "mesh_id")))
  name                 = lookup(var.gateway_route[count.index], "name")
  virtual_gateway_name = try(element(aws_appmesh_virtual_gateway.this.*.name, lookup(var.gateway_route[count.index], "virtual_gateway_id")))
  mesh_owner           = lookup(var.gateway_route[count.index], "mesh_owner")
  tags                 = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.gateway_route[count.index], "tags"))

  dynamic "spec" {
    for_each = lookup(var.gateway_route[count.index], "spec")
    content {
      priority = lookup(spec.value, "priority")

      dynamic "grpc_route" {
        for_each = try(lookup(spec.value, "grpc_route") == null ? [] : ["grpc_route"])
        iterator = grpc
        content {
          dynamic "action" {
            for_each = lookup(grpc.value, "action")
            content {
              dynamic "target" {
                for_each = lookup(action.value, "target")
                content {
                  port = lookup(target.value, "port")

                  dynamic "virtual_service" {
                    for_each = lookup(target.value, "virtual_service")
                    content {
                      virtual_service_name = lookup(virtual_service.value, "virtual_service_name")
                    }
                  }
                }
              }
            }
          }

          dynamic "match" {
            for_each = lookup(grpc.value, "match")
            content {
              service_name = lookup(match.value, "service_name")
              port         = lookup(match.value, "port")
            }
          }
        }
      }

      dynamic "http_route" {
        for_each = try(lookup(spec.value, "http_route") == null ? [] : ["http_route"])
        iterator = http
        content {
          dynamic "action" {
            for_each = lookup(http.value, "action")
            content {
              dynamic "target" {
                for_each = lookup(action.value, "target")
                content {
                  port = lookup(target.value, "port")

                  dynamic "virtual_service" {
                    for_each = lookup(target.value, "virtual_service")
                    content {
                      virtual_service_name = lookup(virtual_service.value, "virtual_service_name")
                    }
                  }
                }
              }
              dynamic "rewrite" {
                for_each = try(lookup(action.value, "rewrite") == null ? [] : ["rewrite"])
                content {
                  dynamic "hostname" {
                    for_each = try(lookup(rewrite.value, "hostname") == null ? [] : ["hostname"])
                    content {
                      default_target_hostname = lookup(hostname.value, "default_target_hostname")
                    }
                  }
                  dynamic "path" {
                    for_each = try(lookup(rewrite.value, "path") == null ? [] : ["path"])
                    content {
                      exact = lookup(path.value, "exact")
                    }
                  }
                  dynamic "prefix" {
                    for_each = try(lookup(rewrite.value, "prefix") == null ? [] : ["prefix"])
                    content {
                      default_prefix = lookup(prefix.value, "default_prefix")
                      value          = lookup(prefix.value, "value")
                    }
                  }
                }
              }
            }
          }

          dynamic "match" {
            for_each = lookup(http.value, "match")
            content {
              port   = lookup(match.value, "port")
              prefix = lookup(match.value, "prefix")

              dynamic "header" {
                for_each = try(lookup(match.value, "header") == null ? [] : ["header"])
                content {
                  name   = lookup(header.value, "name")
                  invert = lookup(header.value, "invert")

                  dynamic "match" {
                    for_each = try(lookup(header.value, "match") == null ? [] : ["match"])
                    content {
                      exact  = lookup(match.value, "exact")
                      prefix = lookup(match.value, "prefix")
                      port   = lookup(match.value, "port")
                      regex  = lookup(match.value, "regex")
                      suffix = lookup(match.value, "suffix")

                      dynamic "range" {
                        for_each = try(lookup(match.value, "range") == null ? [] : ["range"])
                        content {
                          end   = lookup(range.value, "end")
                          start = lookup(range.value, "start")
                        }
                      }
                    }
                  }
                }
              }
              dynamic "hostname" {
                for_each = try(lookup(match.value, "hostname") == null ? [] : ["hostname"])
                content {
                  exact  = lookup(hostname.value, "exact")
                  suffix = lookup(hostname.value, "suffix")
                }
              }
              dynamic "path" {
                for_each = try(lookup(match.value, "path") == null ? [] : ["path"])
                content {
                  exact = lookup(path.value, "exact")
                  regex = lookup(path.value, "regex")
                }
              }
              dynamic "query_parameter" {
                for_each = try(lookup(match.value, "query_parameter") == null ? [] : ["query_parameter"])
                iterator = query
                content {
                  name = lookup(query.value, "name")

                  dynamic "match" {
                    for_each = try(lookup(query.value, "match") == null ? [] : ["match"])
                    content {
                      exact = lookup(match.value, "exact")
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "http2_route" {
        for_each = try(lookup(spec.value, "http2_route") == null ? [] : ["http2_route"])
        iterator = http2
        content {
          dynamic "action" {
            for_each = ""
            content {
              dynamic "target" {
                for_each = ""
                content {
                  port = 0

                  dynamic "virtual_service" {
                    for_each = ""
                    content {
                      virtual_service_name = ""
                    }
                  }
                }
              }
              dynamic "rewrite" {
                for_each = ""
                content {
                  dynamic "hostname" {
                    for_each = ""
                    content {
                      default_target_hostname = ""
                    }
                  }
                  dynamic "path" {
                    for_each = ""
                    content {
                      exact = ""
                    }
                  }
                  dynamic "prefix" {
                    for_each = ""
                    content {
                      default_prefix = ""
                      value          = ""
                    }
                  }
                }
              }
            }
          }

          dynamic "match" {
            for_each = ""
            content {
              port   = 0
              prefix = ""

              dynamic "header" {
                for_each = ""
                content {
                  name   = ""
                  invert = true

                  dynamic "match" {
                    for_each = ""
                    content {
                      exact  = ""
                      prefix = ""
                      port   = 0
                      regex  = ""
                      suffix = ""

                      dynamic "range" {
                        for_each = ""
                        content {
                          end   = 0
                          start = 0
                        }
                      }
                    }
                  }
                }
              }

              dynamic "hostname" {
                for_each = ""
                content {
                  exact  = ""
                  suffix = ""
                }
              }

              dynamic "path" {
                for_each = ""
                content {
                  exact = ""
                  regex = ""
                }
              }

              dynamic "query_parameter" {
                for_each = ""
                content {
                  name = ""

                  dynamic "match" {
                    for_each = ""
                    content {
                      exact = ""
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "aws_appmesh_mesh" "this" {
  count = length(var.mesh)
  name  = lookup(var.mesh[count.index], "name")
  tags  = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.mesh[count.index], "tags"))

  dynamic "spec" {
    for_each = try(lookup(var.mesh[count.index], "spec") == null ? [] : ["spec"])
    content {
      dynamic "egress_filter" {
        for_each = try(lookup(var.mesh[count.index], "egress_filter") == null ? [] : ["egress_filter"])
        iterator = egress
        content {
          type = lookup(egress.value, "type")
        }
      }

      dynamic "service_discovery" {
        for_each = try(lookup(var.mesh[count.index], "service_discovery") == null ? [] : ["service_discovery"])
        iterator = service
        content {
          ip_preference = lookup(service.value, "ip_preference")
        }
      }
    }
  }
}

resource "aws_appmesh_route" "this" {
  count               = (length(var.mesh) && length(var.virtual_router)) == 0 ? 0 : length(var.route)
  mesh_name           = try(element(aws_appmesh_mesh.this.*.id, lookup(var.route[count.index], "mesh_id")))
  name                = lookup(var.route[count.index], "name")
  virtual_router_name = try(element(aws_appmesh_virtual_router.this.*.name, lookup(var.route[count.index], "virtual_router_id")))
  mesh_owner          = lookup(var.route[count.index], "mesh_owner")
  tags                = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.route[count.index], "tags"))

  dynamic "spec" {
    for_each = lookup(var.route[count.index], "spec")
    content {
      priority = lookup(spec.value, "priority")

      dynamic "grpc_route" {
        for_each = try(lookup(spec.value, "grpc_route") == null ? [] : ["grpc_route"])
        iterator = grpc
        content {
          dynamic "action" {
            for_each = try(lookup(grpc.value, "action") == null ? [] : ["action"])
            content {
              dynamic "weighted_target" {
                for_each = try(lookup(action.value, "weighted_target") == null ? [] : ["weighted_target"])
                iterator = target
                content {
                  virtual_node = lookup(target.value, "virtual_node")
                  weight       = lookup(target.value, "weight")
                  port         = lookup(target.value, "port")
                }
              }
            }
          }

          dynamic "match" {
            for_each = try(lookup(grpc.value, "match") == null ? [] : ["match"])
            content {
              method_name  = lookup(match.value, "method_name")
              service_name = lookup(match.value, "service_name")
              port         = lookup(match.value, "port")

              dynamic "metadata" {
                for_each = try(lookup(match.value, "metadata") == null ? [] : ["metadata"])
                iterator = meta
                content {
                  name   = lookup(meta.value, "name")
                  invert = lookup(meta.value, "invert")

                  dynamic "match" {
                    for_each = try(lookup(meta.value, "match") == null ? [] : ["match"])
                    content {
                      exact  = lookup(match.value, "exact")
                      prefix = lookup(match.value, "prefix")
                      port   = lookup(match.value, "port")
                      regex  = lookup(match.value, "regex")
                      suffix = lookup(match.value, "suffix")

                      dynamic "range" {
                        for_each = try(lookup(match.value, "range") == null ? [] : ["range"])
                        content {
                          end   = lookup(range.value, "end")
                          start = lookup(range.value, "start")
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          dynamic "retry_policy" {
            for_each = try(lookup(grpc.value, "retry_policy") == null ? [] : ["retry_policy"])
            iterator = retry
            content {
              max_retries       = lookup(retry.value, "max_retries")
              grpc_retry_events = lookup(retry.value, "grpc_retry_events")
              http_retry_events = lookup(retry.value, "http_retry_events")
              tcp_retry_events  = lookup(retry.value, "tcp_retry_events")

              dynamic "per_retry_timeout" {
                for_each = try(lookup(retry.value, "per_retry_timeout") == null ? [] : ["per_retry_timeout"])
                iterator = prt
                content {
                  unit  = lookup(prt.value, "unit")
                  value = lookup(prt.value, "value")
                }
              }
            }
          }

          dynamic "timeout" {
            for_each = try(lookup(grpc.value, "timeout") == null ? [] : ["timeout"])
            content {
              dynamic "idle" {
                for_each = try(lookup(timeout.value, "idle") == null ? [] : ["idle"])
                content {
                  unit  = lookup(idle.value, "unit")
                  value = lookup(idle.value, "value")
                }
              }
            }
          }
        }
      }

      dynamic "http_route" {
        for_each = try(lookup(spec.value, "http_route") == null ? [] : ["http_route"])
        iterator = http
        content {
          dynamic "action" {
            for_each = try(lookup(http.value, "action") == null ? [] : ["action"])
            content {
              dynamic "weighted_target" {
                for_each = try(lookup(action.value, "weighted_target") == null ? [] : ["weighted_target"])
                iterator = wei
                content {
                  virtual_node = lookup(wei.value, "virtual_node")
                  weight       = lookup(wei.value, "weight")
                  port         = lookup(wei.value, "port")
                }
              }
            }
          }

          dynamic "match" {
            for_each = try(lookup(http.value, "match") == null ? [] : ["match"])
            content {
              prefix = lookup(match.value, "prefix")
              port   = lookup(match.value, "port")
              method = lookup(match.value, "method")
              scheme = lookup(match.value, "scheme")

              dynamic "header" {
                for_each = try(lookup(match.value, "header") == null ? [] : ["header"])
                content {
                  name = lookup(header.value, "name")
                }
              }

              dynamic "path" {
                for_each = try(lookup(match.value, "path") == null ? [] : ["path"])
                content {
                  exact = lookup(path.value, "exact")
                  regex = lookup(path.value, "regex")
                }
              }

              dynamic "query_parameter" {
                for_each = try(lookup(match.value, "query_parameter") == null ? [] : ["query_parameter"])
                iterator = query
                content {
                  name = lookup(query.value, "name")

                  dynamic "match" {
                    for_each = try(lookup(query.value, "match") == null ? [] : ["match"])
                    content {
                      exact = lookup(match.value, "exact")
                    }
                  }
                }
              }
            }
          }

          dynamic "retry_policy" {
            for_each = try(lookup(http.value, "retry_policy") == null ? [] : ["retry_policy"])
            iterator = retry
            content {
              max_retries       = lookup(retry.value, "max_retries")
              http_retry_events = lookup(retry.value, "http_retry_events")
              tcp_retry_events  = lookup(retry.value, "tcp_retry_events")

              dynamic "per_retry_timeout" {
                for_each = try(lookup(retry.value, "per_retry_timeout") == nul ? [] : ["per_retry_timeout"])
                iterator = prt
                content {
                  unit  = lookup(prt.value, "unit")
                  value = lookup(prt.value, "value")
                }
              }
            }
          }

          dynamic "timeout" {
            for_each = try(lookup(http.value, "timeout") == null ? [] : ["timeout"])
            content {
              dynamic "idle" {
                for_each = try(lookup(timeout.value, "idle") == null ? [] : ["idle"])
                content {
                  unit  = lookup(idle.value, "unit")
                  value = lookup(idle.value, "value")
                }
              }
              dynamic "per_request" {
                for_each = try(lookup(timeout.value, "per_request") == null ? [] : ["per_request"])
                iterator = pr
                content {
                  unit  = lookup(pr.value, "unit")
                  value = lookup(pr.value, "value")
                }
              }
            }
          }
        }
      }

      dynamic "http2_route" {
        for_each = try(lookup(spec.value, "http2_route") == null ? [] : ["http2_route"])
        iterator = http2
        content {
          dynamic "action" {
            for_each = try(lookup(http2.value, "action") == null ? [] : ["action"])
            content {
              dynamic "weighted_target" {
                for_each = try(lookup(action.value, "weighted_target") == null ? [] : ["weighted_target"])
                iterator = wei
                content {
                  virtual_node = lookup(wei.value, "virtual_node")
                  weight       = lookup(wei.value, "weight")
                  port         = lookup(wei.value, "port")
                }
              }
            }
          }

          dynamic "match" {
            for_each = try(lookup(http2.value, "match") == null ? [] : ["match"])
            content {
              prefix = lookup(match.value, "prefix")
              port   = lookup(match.value, "port")
              method = lookup(match.value, "method")
              scheme = lookup(match.value, "scheme")

              dynamic "header" {
                for_each = try(lookup(match.value, "header") == null ? [] : ["header"])
                content {
                  name = lookup(header.value, "name")
                }
              }

              dynamic "path" {
                for_each = try(lookup(match.value, "path") == null ? [] : ["path"])
                content {
                  exact = lookup(path.value, "exact")
                  regex = lookup(path.value, "regex")
                }
              }

              dynamic "query_parameter" {
                for_each = try(lookup(match.value, "query_parameter") == null ? [] : ["query_parameter"])
                iterator = query
                content {
                  name = lookup(query.value, "name")

                  dynamic "match" {
                    for_each = try(lookup(query.value, "match") == null ? [] : ["match"])
                    content {
                      exact = lookup(match.value, "exact")
                    }
                  }
                }
              }
            }
          }

          dynamic "retry_policy" {
            for_each = try(lookup(http2.value, "retry_policy") == null ? [] : ["retry_policy"])
            iterator = retry
            content {
              max_retries       = lookup(retry.value, "max_retries")
              http_retry_events = lookup(retry.value, "http_retry_events")
              tcp_retry_events  = lookup(retry.value, "tcp_retry_events")

              dynamic "per_retry_timeout" {
                for_each = try(lookup(retry.value, "per_retry_timeout") == nul ? [] : ["per_retry_timeout"])
                iterator = prt
                content {
                  unit  = lookup(prt.value, "unit")
                  value = lookup(prt.value, "value")
                }
              }
            }
          }

          dynamic "timeout" {
            for_each = try(lookup(http2.value, "timeout") == null ? [] : ["timeout"])
            content {
              dynamic "idle" {
                for_each = try(lookup(timeout.value, "idle") == null ? [] : ["idle"])
                content {
                  unit  = lookup(idle.value, "unit")
                  value = lookup(idle.value, "value")
                }
              }
              dynamic "per_request" {
                for_each = try(lookup(timeout.value, "per_request") == null ? [] : ["per_request"])
                iterator = pr
                content {
                  unit  = lookup(pr.value, "unit")
                  value = lookup(pr.value, "value")
                }
              }
            }
          }
        }
      }

      dynamic "tcp_route" {
        for_each = try(lookup(spec.value, "tcp_route") == null ? [] : ["tcp_route"])
        iterator = tcp
        content {
          dynamic "action" {
            for_each = try(lookup(tcp.value, "action") == null ? [] : ["action"])
            content {
              dynamic "weighted_target" {
                for_each = try(lookup(action.value, "weighted_target") == null ? [] : ["weighted_target"])
                iterator = wei
                content {
                  virtual_node = lookup(wei.value, "virtual_node")
                  weight       = lookup(wei.value, "weight")
                  port         = lookup(wei.value, "port")
                }
              }
            }
          }

          dynamic "match" {
            for_each = try(lookup(tcp.value, "match") == null ? [] : ["match"])
            content {
              port = lookup(match.value, "port")
            }
          }

          dynamic "timeout" {
            for_each = try(lookup(tcp.value, "timeout") == null ? [] : ["timeout"])
            content {
              dynamic "idle" {
                for_each = try(lookup(timeout.value, "idle") == null ? [] : ["idle"])
                content {
                  unit  = lookup(idle.value, "unit")
                  value = lookup(idle.value, "value")
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "aws_appmesh_virtual_gateway" "this" {
  count      = length(var.mesh) == 0 ? 0 : length(var.virtual_gateway)
  mesh_name  = try(element(aws_appmesh_mesh.this.*.id, lookup(var.virtual_gateway[count.index], "mesh_id")))
  name       = lookup(var.virtual_gateway[count.index], "name")
  mesh_owner = lookup(var.virtual_gateway[count.index], "mesh_owner")
  tags       = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.virtual_gateway[count.index], "tags"))

  dynamic "spec" {
    for_each = lookup(var.virtual_gateway[count.index], "spec")
    content {
      dynamic "listener" {
        for_each = lookup(spec.value, "listener")
        iterator = list
        content {
          dynamic "port_mapping" {
            for_each = lookup(list.value, "port_mapping")
            iterator = pma
            content {
              port     = lookup(pma.value, "port")
              protocol = lookup(pma.value, "protocol")
            }
          }

          dynamic "connection_pool" {
            for_each = try(lookup(list.value, "connection_pool") == null ? [] : ["connection_pool"])
            iterator = cpo
            content {
              dynamic "grpc" {
                for_each = try(lookup(cpo.value, "grpc") == null ? [] : ["grpc"])
                content {
                  max_requests = lookup(grpc.value, "max_requests")
                }
              }

              dynamic "http" {
                for_each = try(lookup(cpo.value, "http") == null ? [] : ["http"])
                content {
                  max_connections      = lookup(http.value, "max_connections")
                  max_pending_requests = lookup(http.value, "max_pending_requests")
                }
              }

              dynamic "http2" {
                for_each = try(lookup(cpo.value, "http2") == null ? [] : ["http2"])
                content {
                  max_requests = lookup(http2.value, "max_requests")
                }
              }
            }
          }

          dynamic "health_check" {
            for_each = try(lookup(list.value, "health_check") == null ? [] : ["health_check"])
            iterator = hck
            content {
              healthy_threshold   = lookup(hck.value, "healthy_threshold")
              interval_millis     = lookup(hck.value, "interval_millis")
              protocol            = lookup(hck.value, "protocol")
              timeout_millis      = lookup(hck.value, "timeout_millis")
              unhealthy_threshold = lookup(hck.value, "unhealthy_threshold")
              path                = lookup(hck.value, "path")
              port                = lookup(hck.value, "port")
            }
          }

          dynamic "tls" {
            for_each = try(lookup(list.value, "tls") == null ? [] : ["tls"])
            content {
              mode = lookup(tls.value, "mode")

              dynamic "certificate" {
                for_each = try(lookup(tls.value, "certificate") == null ? [] : ["certificate"])
                iterator = cer
                content {
                  dynamic "acm" {
                    for_each = try(lookup(cer.value, "acm") == null ? [] : ["acm"])
                    content {
                      certificate_arn = try(element(module.acm.*.acmpca_certificate_arn, lookup(acm.value, "certificate_id")))
                    }
                  }
                  dynamic "file" {
                    for_each = try(lookup(cer.value, "file") == null ? [] : ["file"])
                    content {
                      certificate_chain = file(join("/", [path.cwd, "certificate", lookup(file.value, "certificate_chain")]))
                      private_key       = file(join("/", [path.cwd, "certificate", lookup(file.value, "private_key")]))
                    }
                  }
                  dynamic "sds" {
                    for_each = try(lookup(cer.value, "sds") == null ? [] : ["sds"])
                    content {
                      secret_name = lookup(sds.value, "secret_name")
                    }
                  }
                }
              }

              dynamic "validation" {
                for_each = try(lookup(tls.value, "validation") == null ? [] : ["validation"])
                iterator = val
                content {
                  dynamic "subject_alternative_names" {
                    for_each = try(lookup(val.value, "subject_alternative_names") == null ? [] : ["subject_alternative_names"])
                    iterator = san
                    content {
                      dynamic "match" {
                        for_each = lookup(san.value, "match")
                        content {
                          exact = lookup(match.value, "exact")
                        }
                      }
                    }
                  }

                  dynamic "trust" {
                    for_each = lookup(val.value, "trust")
                    content {
                      dynamic "file" {
                        for_each = try(lookup(trust.value, "file") == null ? [] : ["file"])
                        content {
                          certificate_chain = file(join("/", [path.cwd, "certificate", lookup(file.value, "certificate_chain")]))
                        }
                      }

                      dynamic "sds" {
                        for_each = try(lookup(trust.value, "sds") == null ? [] : ["sds"])
                        content {
                          secret_name = lookup(sds.value, "secret_name")
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "logging" {
        for_each = try(lookup(spec.value, "logging") == null ? [] : ["logging"])
        iterator = log
        content {
          dynamic "access_log" {
            for_each = try(lookup(log.value, "access_log") == null ? [] : ["access_log"])
            iterator = acl
            content {
              dynamic "file" {
                for_each = try(lookup(acl.value, "file") == null ? [] : ["file"])
                content {
                  path = lookup(file.value, "path")

                  dynamic "format" {
                    for_each = try(lookup(file.value, "format") == null ? [] : ["format"])
                    content {
                      text = lookup(format.value, "text")

                      dynamic "json" {
                        for_each = try(lookup(format.value, "json") == null ? [] : ["json"])
                        content {
                          key   = lookup(json.value, "key")
                          value = lookup(json.value, "value")
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "backend_defaults" {
        for_each = try(lookup(spec.value, "backend_defaults") == null ? [] : ["backend_defaults"])
        iterator = back
        content {
          dynamic "client_policy" {
            for_each = try(lookup(back.value, "client_policy") == null ? [] : ["client_policy"])
            iterator = clp
            content {
              dynamic "tls" {
                for_each = try(lookup(clp.value, "tls") == null ? [] : ["tls"])
                content {
                  enforce = lookup(tls.value, "enforce")
                  ports   = lookup(tls.value, "ports")

                  dynamic "certificate" {
                    for_each = try(lookup(tls.value, "certificate") == null ? [] : ["certificate"])
                    iterator = cer
                    content {
                      dynamic "file" {
                        for_each = try(lookup(cer.value, "file") == null ? [] : ["file"])
                        content {
                          certificate_chain = file(join("/", [path.cwd, "certificate", lookup(file.value, "certificate_chain")]))
                          private_key       = file(join("/", [path.cwd, "certificate", lookup(file.value, "private_key")]))
                        }
                      }

                      dynamic "sds" {
                        for_each = try(lookup(cer.value, "sds") == null ? [] : ["sds"])
                        content {
                          secret_name = lookup(sds.value, "secret_name")
                        }
                      }
                    }
                  }

                  dynamic "validation" {
                    for_each = try(lookup(tls.value, "validation") == null ? [] : ["validation"])
                    iterator = val
                    content {
                      dynamic "subject_alternative_names" {
                        for_each = try(lookup(val.value, "subject_alternative_names") == null ? [] : ["subject_alternative_names"])
                        iterator = san
                        content {
                          dynamic "match" {
                            for_each = lookup(san.value, "match")
                            content {
                              exact = lookup(match.value, "exact")
                            }
                          }
                        }
                      }

                      dynamic "trust" {
                        for_each = lookup(val.value, "trust")
                        content {
                          dynamic "acm" {
                            for_each = try(lookup(trust.value, "acm") == null ? [] : ["acm"])
                            content {
                              certificate_authority_arns = [try(element(module.acm.*.acmpca_certificate_authority_arn, lookup(acm.value, "certificate_authority_id")))]
                            }
                          }

                          dynamic "file" {
                            for_each = try(lookup(trust.value, "file") == null ? [] : ["file"])
                            content {
                              certificate_chain = file(join("/", [path.cwd, "certificate", lookup(file.value, "certificate_chain")]))
                            }
                          }

                          dynamic "sds" {
                            for_each = try(lookup(trust.value, "sds") == null ? [] : ["sds"])
                            content {
                              secret_name = lookup(sds.value, "secret_name")
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "aws_appmesh_virtual_node" "this" {
  count      = length(var.mesh) == 0 ? 0 : length(var.virtual_node)
  mesh_name  = try(element(aws_appmesh_mesh.this.*.id, lookup(var.virtual_node[count.index], "mesh_id")))
  name       = lookup(var.virtual_node[count.index], "name")
  mesh_owner = lookup(var.virtual_node[count.index], "mesh_owner")
  tags       = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.virtual_node[count.index], "tags"))

  dynamic "spec" {
    for_each = lookup(var.virtual_node[count.index], "spec")
    content {
      dynamic "backend" {
        for_each = try(lookup(spec.value, "backend") == null ? [] : ["backend"])
        iterator = bkd
        content {
          dynamic "virtual_service" {
            for_each = lookup(bkd.value, "virtual_service")
            iterator = vs
            content {
              virtual_service_name = lookup(vs.value, "virtual_service_name")

              dynamic "client_policy" {
                for_each = try(lookup(vs.value, "client_policy") == null ? [] : ["client_policy"])
                iterator = cp
                content {
                  dynamic "tls" {
                    for_each = try(lookup(cp.value, "tls") == null ? [] : ["tls"])
                    content {
                      enforce = lookup(tls.value, "enforce")
                      ports   = lookup(tls.value, "ports")

                      dynamic "certificate" {
                        for_each = try(lookup(tls.value, "certificate") == null ? [] : ["certificate"])
                        iterator = cer
                        content {
                          dynamic "file" {
                            for_each = try(lookup(cer.value, "file") == null ? [] : ["file"])
                            content {
                              certificate_chain = file(join("/", [path.cwd, "certificate", lookup(file.value, "certificate_chain")]))
                              private_key       = file(join("/", [path.cwd, "certificate", lookup(file.value, "private_key")]))
                            }
                          }

                          dynamic "sds" {
                            for_each = try(lookup(cer.value, "sds") == null ? [] : ["sds"])
                            content {
                              secret_name = lookup(sds.value, "secret_name")
                            }
                          }
                        }
                      }

                      dynamic "validation" {
                        for_each = try(lookup(tls.value, "validation") == null ? [] : ["validation"])
                        iterator = val
                        content {
                          dynamic "subject_alternative_names" {
                            for_each = try(lookup(val.value, "subject_alternative_names") == null ? [] : ["subject_alternative_names"])
                            iterator = san
                            content {
                              dynamic "match" {
                                for_each = lookup(san.value, "match")
                                content {
                                  exact = lookup(match.value, "exact")
                                }
                              }
                            }
                          }

                          dynamic "trust" {
                            for_each = lookup(val.value, "trust")
                            content {
                              dynamic "acm" {
                                for_each = try(lookup(trust.value, "acm") == null ? [] : ["acm"])
                                content {
                                  certificate_authority_arns = [try(element(module.acm.*.acmpca_certificate_authority_arn, lookup(acm.value, "certificate_authority_id")))]
                                }
                              }

                              dynamic "file" {
                                for_each = try(lookup(trust.value, "file") == null ? [] : ["file"])
                                content {
                                  certificate_chain = file(join("/", [path.cwd, "certificate", lookup(file.value, "certificate_chain")]))
                                }
                              }

                              dynamic "sds" {
                                for_each = try(lookup(trust.value, "sds") == null ? [] : ["sds"])
                                content {
                                  secret_name = lookup(sds.value, "secret_name")
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "backend_defaults" {
        for_each = try(lookup(spec.value, "backend_defaults") == null ? [] : ["backend_defaults"])
        iterator = bd
        content {
          dynamic "client_policy" {
            for_each = try(lookup(bd.value, "client_policy") == null ? [] : ["client_policy"])
            iterator = cp
            content {
              dynamic "tls" {
                for_each = try(lookup(cp.value, "tls") == null ? [] : ["tls"])
                content {
                  enforce = lookup(tls.value, "enforce")
                  ports   = lookup(tls.value, "ports")

                  dynamic "certificate" {
                    for_each = try(lookup(tls.value, "certificate") == null ? [] : ["certificate"])
                    iterator = cer
                    content {
                      dynamic "file" {
                        for_each = try(lookup(cer.value, "file") == null ? [] : ["file"])
                        content {
                          certificate_chain = file(join("/", [path.cwd, "certificate", lookup(file.value, "certificate_chain")]))
                          private_key       = file(join("/", [path.cwd, "certificate", lookup(file.value, "private_key")]))
                        }
                      }

                      dynamic "sds" {
                        for_each = try(lookup(cer.value, "sds") == null ? [] : ["sds"])
                        content {
                          secret_name = lookup(sds.value, "secret_name")
                        }
                      }
                    }
                  }

                  dynamic "validation" {
                    for_each = try(lookup(tls.value, "validation") == null ? [] : ["validation"])
                    iterator = val
                    content {
                      dynamic "subject_alternative_names" {
                        for_each = try(lookup(val.value, "subject_alternative_names") == null ? [] : ["subject_alternative_names"])
                        iterator = san
                        content {
                          dynamic "match" {
                            for_each = lookup(san.value, "match")
                            content {
                              exact = lookup(match.value, "exact")
                            }
                          }
                        }
                      }

                      dynamic "trust" {
                        for_each = lookup(val.value, "trust")
                        content {
                          dynamic "acm" {
                            for_each = try(lookup(trust.value, "acm") == null ? [] : ["acm"])
                            content {
                              certificate_authority_arns = [try(element(module.acm.*.acmpca_certificate_authority_arn, lookup(acm.value, "certificate_authority_id")))]
                            }
                          }

                          dynamic "file" {
                            for_each = try(lookup(trust.value, "file") == null ? [] : ["file"])
                            content {
                              certificate_chain = file(join("/", [path.cwd, "certificate", lookup(file.value, "certificate_chain")]))
                            }
                          }

                          dynamic "sds" {
                            for_each = try(lookup(trust.value, "sds") == null ? [] : ["sds"])
                            content {
                              secret_name = lookup(sds.value, "secret_name")
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "listener" {
        for_each = try(lookup(spec.value, "listener") == null ? [] : ["listener"])
        iterator = ls
        content {
          dynamic "connection_pool" {
            for_each = try(lookup(ls.value, "connection_pool") == null ? [] : ["connection_pool"])
            iterator = cp
            content {
              dynamic "grpc" {
                for_each = try(lookup(cp.value, "grpc") == null ? [] : ["grpc"])
                content {
                  max_requests = lookup(grpc.value, "max_requests")
                }
              }
              dynamic "http" {
                for_each = try(lookup(cp.value, "http") == null ? [] : ["http"])
                content {
                  max_connections      = lookup(http.value, "max_connections")
                  max_pending_requests = lookup(http.value, "max_pending_requests")
                }
              }
              dynamic "http2" {
                for_each = try(lookup(cp.value, "http2") == null ? [] : ["http2"])
                content {
                  max_requests = lookup(http2.value, "max_requests")
                }
              }
              dynamic "tcp" {
                for_each = try(lookup(cp.value, "tcp") == null ? [] : ["tcp"])
                content {
                  max_connections = lookup(tcp.value, "max_connections")
                }
              }
            }
          }

          dynamic "health_check" {
            for_each = try(lookup(ls.value, "health_check") == null ? [] : ["health_check"])
            iterator = hc
            content {
              healthy_threshold   = lookup(hc.value, "healthy_threshold")
              interval_millis     = lookup(hc.value, "interval_millis")
              protocol            = lookup(hc.value, "protocol")
              timeout_millis      = lookup(hc.value, "timeout_millis")
              unhealthy_threshold = lookup(hc.value, "unhealthy_threshold")
              path                = lookup(hc.value, "path")
              port                = lookup(hc.value, "port")
            }
          }

          dynamic "outlier_detection" {
            for_each = try(lookup(ls.value, "outlier_detection") == null ? [] : ["outlier_detection"])
            iterator = od
            content {
              max_ejection_percent = lookup(od.value, "max_ejection_percent")
              max_server_errors    = lookup(od.value, "max_server_errors")

              dynamic "base_ejection_duration" {
                for_each = try(lookup(od.value, "base_ejection_duration") == null ? [] : ["base_ejection_duration"])
                iterator = bed
                content {
                  unit  = lookup(bed.value, "unit")
                  value = lookup(bed.value, "value")
                }
              }

              dynamic "interval" {
                for_each = try(lookup(od.value, "interval") == null ? [] : ["interval"])
                iterator = int
                content {
                  unit  = lookup(int.value, "unit")
                  value = lookup(int.value, "value")
                }
              }
            }
          }

          dynamic "port_mapping" {
            for_each = try(lookup(ls.value, "port_mapping") == null ? [] : ["port_mapping"])
            iterator = pm
            content {
              port     = lookup(pm.value, "port")
              protocol = lookup(pm.value, "protocol")
            }
          }

          dynamic "timeout" {
            for_each = try(lookup(ls.value, "timeout") == null ? [] : ["timeout"])
            iterator = to
            content {
              dynamic "grpc" {
                for_each = try(lookup(to.value, "grpc") == null ? [] : ["grpc"])
                content {
                  dynamic "idle" {
                    for_each = try(lookup(grpc.value, "idle") == null ? [] : ["idle"])
                    content {
                      unit  = lookup(idle.value, "unit")
                      value = lookup(idle.value, "value")
                    }
                  }
                  dynamic "per_request" {
                    for_each = try(lookup(grpc.value, "per_request") == null ? [] : ["per_request"])
                    content {
                      unit  = lookup(per_request.value, "unit")
                      value = lookup(per_request.value, "value")
                    }
                  }
                }
              }

              dynamic "http" {
                for_each = try(lookup(to.value, "http") == null ? [] : ["http"])
                content {
                  dynamic "idle" {
                    for_each = try(lookup(http.value, "idle") == null ? [] : ["idle"])
                    content {
                      unit  = lookup(idle.value, "unit")
                      value = lookup(idle.value, "value")
                    }
                  }
                  dynamic "per_request" {
                    for_each = try(lookup(http.value, "per_request") == null ? [] : ["per_request"])
                    content {
                      unit  = lookup(per_request.value, "unit")
                      value = lookup(per_request.value, "value")
                    }
                  }
                }
              }

              dynamic "http2" {
                for_each = try(lookup(to.value, "http2") == null ? [] : ["http2"])
                content {
                  dynamic "idle" {
                    for_each = try(lookup(http2.value, "idle") == null ? [] : ["idle"])
                    content {
                      unit  = lookup(idle.value, "unit")
                      value = lookup(idle.value, "value")
                    }
                  }
                  dynamic "per_request" {
                    for_each = try(lookup(http2.value, "per_request") == null ? [] : ["per_request"])
                    content {
                      unit  = lookup(per_request.value, "unit")
                      value = lookup(per_request.value, "value")
                    }
                  }
                }
              }

              dynamic "tcp" {
                for_each = try(lookup(to.value, "tcp") == null ? [] : ["tcp"])
                content {
                  dynamic "idle" {
                    for_each = try(lookup(tcp.value, "idle") == null ? [] : ["idle"])
                    content {
                      unit  = lookup(idle.value, "unit")
                      value = lookup(idle.value, "value")
                    }
                  }
                  dynamic "per_request" {
                    for_each = try(lookup(tcp.value, "per_request") == null ? [] : ["per_request"])
                    content {
                      unit  = lookup(per_request.value, "unit")
                      value = lookup(per_request.value, "value")
                    }
                  }
                }
              }
            }
          }

          dynamic "tls" {
            for_each = try(lookup(ls.value, "tls") == null ? [] : ["tls"])
            content {
              mode = lookup(tls.value, "mode")

              dynamic "certificate" {
                for_each = try(lookup(tls.value, "certificate") == null ? [] : ["certificate"])
                iterator = cer
                content {
                  dynamic "file" {
                    for_each = try(lookup(cer.value, "file") == null ? [] : ["file"])
                    content {
                      certificate_chain = file(join("/", [path.cwd, "certificate", lookup(file.value, "certificate_chain")]))
                      private_key       = file(join("/", [path.cwd, "certificate", lookup(file.value, "private_key")]))
                    }
                  }

                  dynamic "sds" {
                    for_each = try(lookup(cer.value, "sds") == null ? [] : ["sds"])
                    content {
                      secret_name = lookup(sds.value, "secret_name")
                    }
                  }
                }
              }

              dynamic "validation" {
                for_each = try(lookup(tls.value, "validation") == null ? [] : ["validation"])
                iterator = val
                content {
                  dynamic "subject_alternative_names" {
                    for_each = try(lookup(val.value, "subject_alternative_names") == null ? [] : ["subject_alternative_names"])
                    iterator = san
                    content {
                      dynamic "match" {
                        for_each = lookup(san.value, "match")
                        content {
                          exact = lookup(match.value, "exact")
                        }
                      }
                    }
                  }

                  dynamic "trust" {
                    for_each = lookup(val.value, "trust")
                    content {
                      dynamic "acm" {
                        for_each = try(lookup(trust.value, "acm") == null ? [] : ["acm"])
                        content {
                          certificate_authority_arns = [try(element(module.acm.*.acmpca_certificate_authority_arn, lookup(acm.value, "certificate_authority_id")))]
                        }
                      }

                      dynamic "file" {
                        for_each = try(lookup(trust.value, "file") == null ? [] : ["file"])
                        content {
                          certificate_chain = file(join("/", [path.cwd, "certificate", lookup(file.value, "certificate_chain")]))
                        }
                      }

                      dynamic "sds" {
                        for_each = try(lookup(trust.value, "sds") == null ? [] : ["sds"])
                        content {
                          secret_name = lookup(sds.value, "secret_name")
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "logging" {
        for_each = try(lookup(spec.value, "logging") == null ? [] : ["logging"])
        iterator = log
        content {
          dynamic "access_log" {
            for_each = try(lookup(log.value, "access_log") == null ? [] : ["access_log"])
            iterator = acl
            content {
              dynamic "file" {
                for_each = try(lookup(acl.value, "file") == null ? [] : ["file"])
                content {
                  path = lookup(file.value, "path")

                  dynamic "format" {
                    for_each = try(lookup(file.value, "format") == null ? [] : ["format"])
                    content {
                      text = lookup(format.value, "text")

                      dynamic "json" {
                        for_each = try(lookup(format.value, "json") == null ? [] : ["json"])
                        content {
                          key   = lookup(json.value, "key")
                          value = lookup(json.value, "value")
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "service_discovery" {
        for_each = try(lookup(spec.value, "service_discovery") == null ? [] : ["service_discovery"])
        iterator = sd
        content {
          dynamic "aws_cloud_map" {
            for_each = try(lookup(sd.value, "aws_cloud_map") == null ? [] : ["aws_cloud_map"])
            iterator = acm
            content {
              namespace_name = lookup(acm.value, "namespace_name")
              service_name   = lookup(acm.value, "service_name")
              attributes     = lookup(acm.value, "attributes")
            }
          }

          dynamic "dns" {
            for_each = try(lookup(sd.value, "dns") == null ? [] : ["dns"])
            content {
              hostname      = lookup(dns.value, "hostname")
              ip_preference = lookup(dns.value, "ip_preference")
              response_type = lookup(dns.value, "response_type")
            }
          }
        }
      }
    }
  }
}

resource "aws_appmesh_virtual_router" "this" {
  count      = length(var.mesh) == 0 ? 0 : length(var.virtual_router)
  mesh_name  = try(element(aws_appmesh_mesh.this.*.id, lookup(var.virtual_router[count.index], "mesh_id")))
  name       = lookup(var.virtual_router[count.index], "name")
  mesh_owner = lookup(var.virtual_router[count.index], "mesh_owner")
  tags       = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.virtual_router[count.index], "tags"))

  dynamic "spec" {
    for_each = lookup(var.virtual_router[count.index], "spec")
    content {
      dynamic "listener" {
        for_each = try(lookup(spec.value, "listener") == null ? [] : ["listener"])
        content {
          dynamic "port_mapping" {
            for_each = lookup(listener.value, "port_mapping")
            content {
              port     = lookup(port_mapping.value, "port")
              protocol = lookup(port_mapping.value, "protocol")
            }
          }
        }
      }
    }
  }
}

resource "aws_appmesh_virtual_service" "this" {
  count      = length(var.mesh) == 0 ? 0 : length(var.virtual_service)
  mesh_name  = try(element(aws_appmesh_mesh.this.*.id, lookup(var.virtual_service[count.index], "mesh_id")))
  name       = lookup(var.virtual_service[count.index], "name")
  mesh_owner = lookup(var.virtual_service[count.index], "mesh_owner")
  tags       = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.virtual_service[count.index], "tags"))

  dynamic "spec" {
    for_each = lookup(var.virtual_service[count.index], "spec")
    content {
      dynamic "provider" {
        for_each = try(lookup(spec.value, "provider") == null ? [] : ["provider"])
        content {
          dynamic "virtual_node" {
            for_each = try(lookup(provider.value, "virtual_node") == null ? [] : ["virtual_node"])
            iterator = node
            content {
              virtual_node_name = try(element(aws_appmesh_virtual_node.this.*.name, lookup(node.value, "virtual_node_id")))
            }
          }
          dynamic "virtual_router" {
            for_each = try(lookup(provider.value, "virtual_router") == null ? [] : ["virtual_router"])
            iterator = router
            content {
              virtual_router_name = try(element(aws_appmesh_virtual_router.this.*.name, lookup(router.value, "virtual_router_id")))
            }
          }
        }
      }
    }
  }
}
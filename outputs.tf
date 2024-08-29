## GATEWAY ROUTE

output "gateway_route_id" {
  value = try(aws_appmesh_gateway_route.this.*.id)
}

output "gateway_route_name" {
  value = try(aws_appmesh_gateway_route.this.*.name)
}

output "gateway_route_arn" {
  value = try(aws_appmesh_gateway_route.this.*.arn)
}

## MESH

output "mesh_name" {
  value = try(
    aws_appmesh_mesh.this.*.name
  )
}

output "mesh_id" {
  value = try(aws_appmesh_mesh.this.*.id)
}

output "mesh_arn" {
  value = try(aws_appmesh_mesh.this.*.arn)
}

## ROUTE

output "route_id" {
  value = try(aws_appmesh_route.this.*.id)
}

output "route_name" {
  value = try(aws_appmesh_route.this.*.name)
}

output "route_arn" {
  value = try(aws_appmesh_route.this.*.arn)
}

## VIRTUAL GATEWAY

output "virtual_gateway_id" {
  value = try(
    try(aws_appmesh_virtual_gateway.this.*.id)
  )
}

output "virtual_gateway_name" {
  value = try(
    aws_appmesh_virtual_gateway.this.*.name
  )
}

output "virtual_gateway_arn" {
  value = try(aws_appmesh_virtual_gateway.this.*.arn)
}

## VIRTUAL NODE

output "virtual_node_id" {
  value = try(aws_appmesh_virtual_node.this.*.id)
}

output "virtual_node_name" {
  value = try(aws_appmesh_virtual_node.this.*.name)
}

output "virtual_node_arn" {
  value = try(
    aws_appmesh_virtual_node.this.*.arn
  )
}

## VIRTUAL ROUTER

output "virtual_router_id" {
  value = try(
    aws_appmesh_virtual_router.this.*.id
  )
}

output "virtual_router_name" {
  value = try(
    aws_appmesh_virtual_router.this.*.name
  )
}

output "virtual_router_arn" {
  value = try(
    aws_appmesh_virtual_router.this.*.arn
  )
}

## VIRTUAL SERVICE

output "virtual_service_id" {
  value = try(
    aws_appmesh_virtual_service.this.*.id
  )
}

output "virtual_service_name" {
  value = try(
    aws_appmesh_virtual_service.this.*.name
  )
}

output "virtual_service_arn" {
  value = try(
    aws_appmesh_virtual_service.this.*.arn
  )
}
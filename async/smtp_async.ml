open Core.Std
open Async.Std

module IO = struct
  type 'a t = 'a Deferred.t
  let return = Deferred.return
  let bind   = Deferred.bind
  let fail exn = raise exn

  type ic = Reader.t
  type oc = Writer.t

  let open_connection ~host ~service =
    let port = 
      try Int.of_string service 
      with _ -> failwith "Async backend expects an integer service specification"
    in
    let where_to_connect = Tcp.to_host_and_port host port in
    Tcp.connect where_to_connect
    >>| fun (socket, reader, writer) ->
    (reader, writer)

  let shutdown_connection = Reader.close

  let read_line r = 
    Reader.read_line r
    >>= function
    | `Ok s -> return s
    | `Eof  -> failwith "got EOF on connection"

  let print_line w s = 
    Writer.write_line w (s ^ "\r\n"); 
    Writer.flushed w
end

module Smtp = Smtp.Make (IO)
include Smtp

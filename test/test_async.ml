open Smtp_async

let () = 
  sendmail
    ~port:"2525"
    ~name:"localhost"
    ~from:Addr.(of_string "test@example.org")
    ~to_:[Addr.(of_string "test@example.org")]
    ~body:"Bleh" () 
  >>> (function
  | `Ok (code, msg) -> Printf.printf "OK %d %s\n" code msg
  | `Failure (code, msg) -> Printf.eprintf "Failure %d %s\n" code msg);
  never_returns (Scheduler.go ())

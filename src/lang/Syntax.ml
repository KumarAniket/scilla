(*
 * Copyright (c) 2018 - present , Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *)

open Sexplib.Std

type 'rep ident =
  | Ident of string * 'rep
  [@@deriving sexp]

type typ  =
  | PrimType of string
  | MapType of typ * typ
  | FunType of typ * typ
  | ADT of string * typ list
  | TypeVar of string
  | PolyFun of string * typ
[@@deriving sexp]

type 'rep pattern =
  | Wildcard
  | Binder of 'rep ident
  | Constructor of string * ('rep pattern list)
[@@deriving sexp]

type literal = 
  | IntLit of int
  | BNum of int
  | Address of string
  | Sha256 of string
  (* A dynamic map of literals *)    
  | Map of (literal * literal) list
  (* A constructor in HNF *)      
  | ADTValue of string * typ list * literal list
[@@deriving sexp]

type 'rep payload =
  | MTag of string
  | MLit of literal
  | MVar of 'rep ident
[@@deriving sexp]

type 'rep expr =
  | Let of 'rep ident * typ option * 'rep expr * 'rep expr
  | Var of 'rep ident
  | Literal of literal
  | Message of (string * 'rep payload) list
  | Builtin of 'rep ident * 'rep ident list 
  | Fun of 'rep ident * typ * 'rep expr
  | App of 'rep ident * 'rep ident list
  | TFun of 'rep ident * 'rep expr
  | TApp of 'rep ident * typ list
  | Constr of string * typ list * 'rep ident list
  | MatchExpr of 'rep ident * ('rep pattern * 'rep expr) list
[@@deriving sexp]

type 'rep stmt =
  | Load of 'rep ident * 'rep ident
  | Store of 'rep ident * 'rep ident
  | Bind of 'rep ident * 'rep expr
  | ReadFromBC of 'rep ident * string
  | AcceptPayment of 'rep ident
  | SendMsgs of 'rep ident
  | MatchStmt of 'rep ident * ('rep pattern * 'rep stmt list) list
  | Event of 'rep ident
  | Throw of 'rep ident
[@@deriving sexp]

type 'rep transition = 
  { tname   : 'rep ident;
    tparams : ('rep ident  * typ) list;
    tbody   : 'rep stmt list }
[@@deriving sexp]

type 'rep lib_entry =
  { lname : 'rep ident;
    lexp  : 'rep expr }
[@@deriving sexp]

type 'rep contract =
  { cname   : 'rep ident;
    cparams : ('rep ident  * typ) list;
    cfields : ('rep ident * typ * 'rep expr) list;
    ctrans  : 'rep transition list; }
[@@deriving sexp]

(* Contrac module: libary + contract definiton *)
type 'rep cmodule =
  { cname : 'rep ident;
    libs  : 'rep lib_entry list;
    contr : 'rep contract }
[@@deriving sexp]


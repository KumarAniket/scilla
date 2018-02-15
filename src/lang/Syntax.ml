(*
 * Copyright (c) 2018 - present Zilliqa, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *)

open Sexplib.Std

type expr = 
    Var of string
  | Not of expr
  | And of expr * expr
  | Or of expr * expr [@@deriving sexp]

let rec exp_to_string e =
  match e with
    | Not p -> "~" ^ exp_to_string p
    | And (p1, p2) -> "(" ^ exp_to_string p1 ^ " ∧ " ^ exp_to_string p2 ^ ")"
    | Or (p1, p2) -> "(" ^ exp_to_string p1 ^ " ∨ " ^ exp_to_string p2 ^ ")"
    | Var s -> s



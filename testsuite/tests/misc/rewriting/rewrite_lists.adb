with Ada.Text_IO; use Ada.Text_IO;

with Langkit_Support.Text; use Langkit_Support.Text;
with Libfoolang.Analysis;  use Libfoolang.Analysis;
with Libfoolang.Rewriting; use Libfoolang.Rewriting;

procedure Rewrite_Lists is
   Ctx : constant Analysis_Context := Create;
   U   : constant Analysis_Unit :=
      Get_From_Buffer (Ctx, "main.txt", Buffer => "");
   RH  : Rewriting_Handle := Start_Rewriting (Ctx);
   N   : constant Node_Rewriting_Handle := Handle (Root (U));

   function Create_Def (Name, Lit : Text_Type) return Node_Rewriting_Handle;

   ----------------
   -- Create_Def --
   ----------------

   function Create_Def (Name, Lit : Text_Type) return Node_Rewriting_Handle is
   begin
      return Create_Def (RH,
                         Create_Token_Node (RH, Foo_Name, Name),
                         Create_Token_Node (RH, Foo_Literal, Lit));
   end Create_Def;

begin
   Insert_Child
     (N, 1, Create_Def ("a", "1"));
   Append_Child (N, Create_Def ("b", "2"));
   Append_Child (N, Create_Def ("c", "3"));
   Remove_Child (N, 2);

   Put_Line ("Applying the diff...");
   if not Apply (RH) then
      Put_Line ("Could not parse the following:");
      Put_Line (Image (Unparse (N)));
      raise Program_Error;
   end if;

   Root (U).Print (Show_Slocs => False);

   Put_Line ("rewrite_lists.adb: Done.");
end Rewrite_Lists;
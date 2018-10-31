This is thoughtless-patch to lua that keeps a length field in the C struct of
the table. It behaves as the following:

- A length is kept in a new field of the table struct (intialized to 0)
- Length-operator/opcode return it
- The length is changed every time something is written in `t[#t+1]` (nil also).
- ipairs loops from 1 to this length, also if there are holes
- The table.setlen function can be used to set the value of the new
field. It does not change anything else.

The execution time increases by ~1% (when updating the length) while the memory
size increases by ~8% (when storing empty tables).


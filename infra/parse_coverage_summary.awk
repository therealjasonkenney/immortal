BEGIN {
  print "| COV | FILE | LINES | RELEVANT | MISSED |"
  print "| --- | ---- | ----- | -------- | ------ |"
}

/----------------/,EOF {
  {i++}
  if(i>2 && NF==5) { print "|" $1 " | " $2 " | " $3 " | " $4 " | " $5 " | "}
  if(i>2 && NF==2) { print "| **TOTAL** | **" $2 "** |" }
}

if __FILE__ == $0
  # TODO Generated stub
end
# This code is in the public domain do with it as you wish
# If you like it then please let me know kolomona@kolomona.com
# If you don't like it then don't let me know unless you have something useful and positive to tell me. :)
# This is a little ruby utility script that I wrote that will take Bank Of America's (BoA) QIF output file
# and spit out ledger's data file format


# The path and file name of BoA's QIF file
infilepath = 'c:\ledger\01-2010.qif' 

# The path end file name of the file Ledger data file we are creating
outfilepath = 'c:\ledger\01-2010.dat' 


def accountcheck(payee)
  # This function looks at the payee string and returns the transaction account based on the hash @accounts
  # defined in the accountdefs.rb

  require "accountdefs.rb" # 
  account = "Expenses:Misc" # Set Default Account
  
  @accounts.each {|search, acct|
    if payee.include? search
      account = acct
    end
  }
  return account
end


infile = File.open(infilepath, 'r') #Open the QIF file for reading
outfile = File.open(outfilepath, 'w') #Open the Output file for writing
numlines = 0 # Set line counter counter to zero
numtrans = 0 # Set transaction counter to zero

while inline = infile.gets #Loop through all the lines in the QIF file
  
  case inline[0].chr # The 1st character determines which type of line it is

    when "!"
      # Its a type Line

    when "D"
      # It's a Date Line
      # Reformat Date String because BoA's date structure is incorrect for Ledger
      month = inline[1,2]
      day = inline[4,2]
      year = inline[7,4]
      outdate =  year+"/"+day+"/"+month

    when "T"
      # It's a Transaction Amount Line
      amount = inline[1..9999]
            
    when "C"
      # It's a Transaction Status Line
      status = inline[1,1]

    when "P"
      # It's a Payee Line
      payee = inline[1..9999]
      # Call function that checks the payee string and determines which account to place the transaction in
      account = accountcheck(payee)

    when "^"
      # It's an End of Record Line
      # Build Ledger record and put it in the output file
      numtrans = numtrans + 1
      outfile.puts outdate + " " + status + " " + payee
      outfile.puts "  Assets:Bank:Checking        " + amount      
      outfile.puts "  " + account
      
   end
end
puts "Finished processing " + numlines.to_s + " for " + numtrans.to_s + " transactions"



class List < ActiveRecord::Base
	# You can create an object piece by piece (one attribute at a time)
	#	
	# However, if you try to create it all at once with lots of attributes being 
	# passed in at once i.e myObject = Object.new(parm1,parm2...parm5)
	# Rails will complaine because someone might try to sneak in malicious settings, attributes,etc.
	# This is called "Mass-assignment" and it is potentially risk.
	# 
	#
	# SO you have to set the specific attributes to "assignable" in order to assign them
 
	attr_accessible :name
	has_many :tasks        
end

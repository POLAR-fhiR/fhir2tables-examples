( all.patients.count <- as.numeric(
	fhiR::tag.attr( 
		fhiR::download.bundle( 
			"https://vonk.fire.ly/R4/Patient?_format=xml&_summary=count"
		),
		"total/@value"
	)
) )

( all.gender.patients.count <- as.numeric(
	fhiR::tag.attr( 
		fhiR::download.bundle( 
			"https://vonk.fire.ly/R4/Patient?_format=xml&_summary=count&gender=male,female"
		),
		"total/@value"
	)
) )

( female.patients.count <- as.numeric(
	fhiR::tag.attr( 
		fhiR::download.bundle( 
			"https://vonk.fire.ly/R4/Patient?_format=xml&_summary=count&gender=female"
		),
		"total/@value"
	)
) )

( male.patients.count <- as.numeric(
	fhiR::tag.attr( 
		fhiR::download.bundle( 
			"https://vonk.fire.ly/R4/Patient?_format=xml&_summary=count&gender=male"
		),
		"total/@value"
	)
) )

all.gender.patients.count - female.patients.count - male.patients.count

b <- fhiR::download.bundle( 
	"https://vonk.fire.ly/R4/Patient?_format=xml"
)

nname <- fhiR::tag.attr( b, ".//name/given/@value" )
vname <- fhiR::tag.attr( b, ".//name/family/@value" )


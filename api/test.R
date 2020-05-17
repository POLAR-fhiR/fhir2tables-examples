( all.patients.count <- as.numeric(
	fhiR::bundle.tag.attr( 
		fhiR::download.page( 
			"https://vonk.fire.ly/R4/Patient?_format=xml&_summary=count"
		),
		"total/@value"
	)
) )

( all.gender.patients.count <- as.numeric(
	fhiR::bundle.tag.attr( 
		fhiR::download.page( 
			"https://vonk.fire.ly/R4/Patient?_format=xml&_summary=count&gender=male,female"
		),
		"total/@value"
	)
) )

( female.patients.count <- as.numeric(
	fhiR::bundle.tag.attr( 
		fhiR::download.page( 
			"https://vonk.fire.ly/R4/Patient?_format=xml&_summary=count&gender=female"
		),
		"total/@value"
	)
) )

( male.patients.count <- as.numeric(
	fhiR::bundle.tag.attr( 
		fhiR::download.page( 
			"https://vonk.fire.ly/R4/Patient?_format=xml&_summary=count&gender=male"
		),
		"total/@value"
	)
) )

all.gender.patients.count - female.patients.count - male.patients.count

b <- fhiR::download.bundle( 
	"https://vonk.fire.ly/R4/Patient?_format=xml"
)

nname <- fhiR::bundle.tag.attr( b$`https://vonk.fire.ly/R4/Patient?_format=xml&_sort=-_lastUpdated&_count=10&_skip=40`, ".//name/given/@value" )
vname <- fhiR::bundle.tag.attr( b$`https://vonk.fire.ly/R4/Patient?_format=xml&_sort=-_lastUpdated&_count=10&_skip=40`, ".//name/family/@value" )

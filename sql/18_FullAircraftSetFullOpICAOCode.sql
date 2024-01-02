UPDATE FullAircraft
SET OperatorFlagCode = OperatorFlagCode || '-' || ICAOTypeCode
WHERE OperatorFlagCode
IN (
	'VJT', /*VistaJet*/
	'EJA', /*Netjets Aviation*/
	'LXJ', /*Flexjet*/
	'FJO', /*Flexjet Operations Malta*/
	'EJM', /*Executive Jet Management*/
	'JME'  /*EJME (Portugal) Aircraft Management*/
);

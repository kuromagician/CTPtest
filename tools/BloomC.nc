/*
 *This is the bloom filter's confuguration file,
 *actual implementation is in bloomP.nc
 * 
 * 
 * Author: Si Li
 * Data: 11-03-2014
 */

configuration BloomC{
	provides interface Init;
	provides interface bloom;
}

implementation {
	components MainC;
	components BloomP;
	
	Init = BloomP;
	MainC.SoftwareInit -> BloomP;
	
	bloom = BloomP;
}
package yelp.utils
{
	
	import com.hurlant.util.Base64;
	
	import flash.utils.ByteArray;
	
	import yelp.YelpTokenSet;
	
	public function makeOAuthSignature(tokenSet:YelpTokenSet,base:String):String
	{		
		var key:ByteArray=new ByteArray();
		//key.writeUTFBytes(tokenSet.oauthTokenSecret);
		key.writeUTFBytes(tokenSet.consumerKeySecret+"&"+tokenSet.oauthTokenSecret);
		var data:ByteArray=new ByteArray();
		data.writeUTFBytes(base);
		return Base64.encodeByteArray(hmac.compute(key,data));
	}
		
}

import com.hurlant.crypto.hash.HMAC;
import com.hurlant.crypto.hash.SHA1;
var hmac:HMAC=new HMAC(new SHA1());
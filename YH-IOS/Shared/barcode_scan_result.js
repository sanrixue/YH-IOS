 (function(){ 
 var response = {"商品编码":"2100000011551","门店名单":"鲁班路店","SKU":"精品超市购物袋大号","日期":"销售额(订单量)","20160613":"109.5(365)","20160612":"97.8(326)","20160611":"118.2(394)","20160610":"146.7(489)","20160609":"161.7(539)","20160608":"122.4(408)","20160607":"107.7(359)","order_keys":["商品编码","门店名单","SKU","日期","20160613","20160612","20160611","20160610","20160609","20160608","20160607"],"code":200}, 
     order_keys = response.order_keys, 
     array = [], 
     key, value, i; 
 for(i = 0; i < order_keys.length; i++) { 
   key = order_keys[i]; 
   value = response[key]; 
   array.push('<tr><td>' + key + '</td><td>' + value + '</td></tr>') 
 } 
 document.getElementById('result').innerHTML = array.join(''); 
}).call(this);
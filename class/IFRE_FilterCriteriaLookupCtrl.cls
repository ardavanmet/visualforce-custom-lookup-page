public class IFRE_FilterCriteriaLookupCtrl{

    public String fieldTypeForSelectedField {get;set;}     
    public list<IFRE_StringSelectedWrapper> listOfLookupsElement {get;set;}
    public String objectName {get;set;}
    public String fieldName {get;set;}
    //public String searchByName{get;set;}
    //public String searchByPhone{get;set;}
    public boolean isChecked {get;set;}
    public String valuePassToFilterPage {get;set;}
    //public String phoneNamePassToHdn {get;set;}

    public boolean isAllSelectCheckBox {get;set;}
    /*Controller*/
    public IFRE_FilterCriteriaLookupCtrl(){
        listOfLookupsElement = new list<IFRE_StringSelectedWrapper>();        
        objectName = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('oN'));
        fieldName = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('fN'));
        isAllSelectCheckBox = false;
        //searchByPhone = '';
        //searchByName ='';
        valuePassToFilterPage = '';
        getlistOfLookupsElement();
   }
   /*to get list of lookup element*/
   public void getlistOfLookupsElement(){
        try{ 
            listOfLookupsElement = new list<IFRE_StringSelectedWrapper>();
            
            /*Schema.DescribeFieldResult fieldResult = Address__c.Valid_Address__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
           for( Schema.PicklistEntry f : ple){
              listOfLookupsElement.add(new IFRE_StringSelectedWrapper(f.getValue(), false));
           }*/    
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);//From the Object Api name retrieving the SObject
            Sobject Object_name = targetType.newSObject();
            Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
            List<Schema.PicklistEntry> ple = field_map.get(fieldName).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
            for (Schema.PicklistEntry val : ple) { //for all values in the picklist list
                listOfLookupsElement.add(new IFRE_StringSelectedWrapper(val.getValue(), false));
              //lstPickvals.add(a.getValue());//add the value  to our final list
            }   
            /*String query = 'SELECT Name,'+fieldName+' FROM '+objectName;
            list<SObject> s = Database.query(query);
            String CountryCode = null; 
            for(sObject sObj:s){ 
                CountryCode = null; 
                isCountryCodeAlreadyExist = false;    
                if(sObj.get(fieldName) != null && sObj.get('Name') != null){
                    if(String.valueOf(sObj.get(fieldName)).startsWith('+1')){
                        CountryCode = '+1';
                    }
                    //listOfLookupsElement.add(new PhoneNumberDetail(String.valueOf(sObj.get('Name')),CountryCode,String.valueOf(sObj.get(fieldName)),false,isCountryCodeAlreadyExist));                     
                }
            } */
        }catch(Exception ex){
             apexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Parameter is not defined, Please contact your Administrator!'));
        }       
    }
    /*Search event*/
    public void onSearch(){      
    }
    /*Event for check box checked*/
    public void onCheck(){
        valuePassToFilterPage = '';
        for(IFRE_StringSelectedWrapper strWrapper :listOfLookupsElement){
            if(strWrapper.isChecked){
                valuePassToFilterPage += strWrapper.str+',';
            }
        }
    }
    /*Event for all select in single check*/
    public void onSelectAll(){
        valuePassToFilterPage = '';
       
        for(IFRE_StringSelectedWrapper strWrapper:listOfLookupsElement){
            if(isAllSelectCheckBox){
                strWrapper.isChecked = true;
            }else{
                strWrapper.isChecked = false;
            }           
            if(strWrapper.isChecked){
                valuePassToFilterPage += strWrapper.str+',';
            }
        }
    }
    /*Detail wrapper*/
    public class IFRE_StringSelectedWrapper{
        public String str {get; set;} 
        public Boolean isChecked{get; set;}
        
        public IFRE_StringSelectedWrapper(String str, Boolean isChecked){
            this.str = str;
            this.isChecked= isChecked;
        }
    }  

}
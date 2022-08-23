public class PublicSiteHospitalController {


    public Doctor__c doctor { get; set; }
        Integer doctorsNumber = 5;


        private Set<Integer> getRandomNumbers(Integer doctorsNumber, List<Doctor__c> allDoctors){
            Set<Integer> randomNumbers = new Set<Integer>();
            Integer randomNumber;
            do{
                randomNumber = Integer.valueof((Math.random() * allDoctors.size()));
                if(!randomNumbers.contains(randomNumber)){
                    randomNumbers.add(randomNumber);
                }
            } while(randomNumbers.size() < doctorsNumber);
            return randomNumbers;
        }

        private List<Doctor__c> getRandomDoctors(Integer doctorsNumber){
            List<Doctor__c> allDoctors = getAllDoctors();
            List<Doctor__c> randomDoctors = new List<Doctor__c>();
            Set<Integer> randomNumbers = getRandomNumbers(doctorsNumber, allDoctors);

            for (Integer randomNumber : randomNumbers){
                randomDoctors.add(allDoctors.get(randomNumber));
            }
            return randomDoctors;
        }

        public List<Doctor__c> getAllDoctors() {
            return [
                    SELECT Name, Doctor_Name__c, Country__c, Birthday_Month__c, Birth_Day__c
                    FROM Doctor__c
                    LIMIT 50000
            ];
        }

        public List<Doctor__c> getDoctors(){
            return getRandomDoctors(doctorsNumber);
        }
    }
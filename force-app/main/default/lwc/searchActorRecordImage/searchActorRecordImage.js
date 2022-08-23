import { LightningElement, api } from 'lwc';
import defauldMaleActor from '@salesforce/resourceUrl/defaultActor';
import defauldFemaleActor from '@salesforce/resourceUrl/defaultFemaleAvatar';

export default class SearchActorRecordImage extends LightningElement {

    @api upcomingActorData;

    get imgAdress() {
        if (this.upcomingActorData.profile_path == null && this.upcomingActorData.gender == 2) {
            return defauldMaleActor;
        } else if (this.upcomingActorData.profile_path == null && this.upcomingActorData.gender != 2) {
            return defauldFemaleActor;
        } else {
            return 'https://image.tmdb.org/t/p/w600_and_h900_bestv2' + this.upcomingActorData.profile_path;
        }
    }
}
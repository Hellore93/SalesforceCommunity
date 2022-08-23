import { LightningElement, track, wire } from 'lwc';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import startSearch from '@salesforce/apex/ComunityAvenirHouseSearcher.startSearch';
import Salesforce_Images from '@salesforce/resourceUrl/IconAvenir';
import itemAvailable from '@salesforce/apex/ComunityAvenirHouseOrder.itemAvailable';


export default class AvenirHouseSearcherResults extends LightningElement {
    @track houseList;
    @track firstHouseList;
    @wire(CurrentPageReference) pageRef;
    comboboxValue = 'Any';
    House;
    Penthouse;
    Island;
    Apartment;
    searchSectionArrow = 'utility:chevronright';
    settingsBool = false;
    startDate;
    endDate;
    counter = 0;
    item = 8;
    counterLimit;
    paginationList;

    House = Salesforce_Images + '/Domes.jpg';
    Penthouse = Salesforce_Images + '/HistoricalHomes.jpg';
    Island = Salesforce_Images + '/islnd.jpg';
    Apartment = Salesforce_Images + '/Mansion.jpg';
    Mountain = Salesforce_Images + '/Mountan.jpg';

    connectedCallback() {
        registerListener('eventdetails', this.sutUpDetails, this);
    }

    @wire(startSearch, { houseName: '' })
    data({ error, data }) {
        if (data) {
            this.houseList = data;
            this.firstHouseList = data;
            this.paginationList = data;
            this.dateSet();
            this.counterLimit = data.length / this.item;
            this.pagination();
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    };

    dateSet() {
        this.startDate = new Date().toISOString();
        this.endDate = new Date().toISOString();
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    sutUpDetails(houseListEvent) {
        const newData = JSON.parse(houseListEvent);
        this.houseList = newData;
        this.firstHouseList = newData;
        this.paginationList = newData;
        this.pagination();
    }

    house(event) {
        const listObj = this.template.querySelectorAll('.active');
        const stringId = event.currentTarget.id.slice(0, -3);
        const elementId = stringId + "P";
        console.log(JSON.parse(JSON.stringify(elementId)));
        console.log(JSON.parse(JSON.stringify(listObj)));
        // console.log(elementId);
        // console.log(listObj);
        console.log(this.template.querySelector(`.${elementId}`));
        if (this.template.querySelector(`.${elementId}`).className.includes('active')) {
            this.template.querySelector(`.${elementId}`).classList.remove('active');
        } else {
            listObj[0] ? listObj[0].classList.remove('active') : null;
            this.template.querySelector(`.${elementId}`).classList.add('active');
        }

        if (this.comboboxValue == stringId) {
            this.comboboxValue = ''
        } else {
            this.comboboxValue = event.currentTarget.id.slice(0, -3);
        }
        this.listFilter();
    }

    listFilter() {
        if (this.comboboxValue != '') {
            const newList = this.firstHouseList.filter(item => item.product.Family == this.comboboxValue);
            this.houseList = newList;
            this.paginationList = newList;
            this.counter = 0;
            this.pagination();
        } else {
            this.houseList = this.firstHouseList;
            this.paginationList = this.firstHouseList;
            this.counter = 0;
            this.pagination();
        }
    }

    serachSection() {
        this.searchSectionArrow == 'utility:chevronright' ?
            this.searchSectionArrow = 'utility:chevronleft' :
            this.searchSectionArrow = 'utility:chevronright'
        this.settingsBool = !this.settingsBool;
    }

    get results() {
        if (this.houseList) {
            return this.houseList;
        }
        return null;
    };

    get productFamilyOptions() {
        if (this.productFamily) {
            return [...this.productFamily];
        }
    }


    filterSearch() {

        itemAvailable({}).then(
            result => {
                let newVariable = this.checkAvailable(result)
                let newArr = this.firstHouseList;

                newVariable.forEach(elem => {
                    if (newArr) {
                        newArr = newArr.filter(element => {
                            let test = element.product.Id != elem.Product2Id
                            return test;
                        })
                    }
                })
                this.houseList = newArr;
                this.paginationList = newArr;
                this.pagination();
            }
        )
    }

    checkAvailable(result) {
        let overlapObject = []
        let startDate = new Date(this.template.querySelector(".startDate").value);
        let endDate = new Date(this.template.querySelector(".endDate").value);

        result.forEach(element => {
            if (
                (startDate > new Date(element.ServiceDate) && startDate < new Date(element.EndDate)) ||
                (endDate > new Date(element.ServiceDate) && endDate < new Date(element.EndDate)) ||
                (startDate < new Date(element.ServiceDate) && endDate > new Date(element.EndDate))
            ) {
                overlapObject.push(element);
            }
        })
        return overlapObject;
    }

    clear() {
        this.houseList = this.firstHouseList;
        this.paginationList = this.firstHouseList;
        this.pagination();
    }

    back() {
        this.counterLimit = this.paginationList.length / this.item;
        this.counter--
            this.counter < 0 ? this.counter = 0 : '';
        this.pagination();
    }

    next() {
        this.counterLimit = this.paginationList.length / this.item;
        this.counter++
            this.counter > this.counterLimit - 1 ? this.counter = this.counterLimit - 1 : '';
        this.pagination();
    }

    pagination() {
        let paginationList = []
        for (let i = 1; i <= this.item; i++) {
            if (this.paginationList[((this.counter * this.item) + i) - 1]) {
                paginationList.push(this.paginationList[((this.counter * this.item) + i) - 1]);
            }
        }
        this.houseList = paginationList
    }

    get options() {
        return [
            { label: '2', value: 2 },
            { label: '5', value: 5 },
            { label: '8', value: 8 },
            { label: '10', value: 10 }
        ]
    }

    handleChange(event) {
        this.counter = 0;
        this.item = event.detail.value;
        this.pagination();
    }
}
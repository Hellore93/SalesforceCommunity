({
    closeModal: function(cmp, evt, helper) {
        helper.closeModal(cmp, evt);
    },

    // handleSuccess: function(cmp, event, helper) {
    //     console.log(event.getParam("id"));
    //     cmp.set('v.recordId', event.getParam("id"));
    //     cmp.set('v.recordName', event.getParam('fields').Name.value);
    //     cmp.set('v.productDetails', false);
    //     cmp.set('v.productPhoto', true);
    //     console.log(cmp.get('v.recordId'));
    // },

    handleSuccess: function(cmp, event, helper) {
        var payload = event.getParams().response;;
        cmp.set('v.recordId', payload.id);
        cmp.set('v.recordName', event.getParams('fields').response.fields.Name.value);
        cmp.set('v.productDetails', false);
        cmp.set('v.productPhoto', true);
        console.log(cmp.get('v.recordId'));
    },

    handleUploadFinished: function(cmp, evt, helper, action) {
        const uploadedFiles = evt.getParam("files");
        console.log(uploadedFiles);
        let photoLink = '';
        uploadedFiles.forEach(file =>
            photoLink = 'https://britenet93-dev-ed.my.salesforce.com/sfc/servlet.shepherd/document/download/' + file.documentId
        );
        var action = cmp.get('c.saveProductMainPhoto');
        action.setParams({
            productId: cmp.get('v.recordId'),
            photoLink: photoLink
        });
        // helper.saveProductDetails(cmp, evt, action);
        helper.getPhoto(cmp, evt);
    },

    goToPriceSection: function(cmp, event) {
        cmp.set('v.productPhoto', false);
        cmp.set('v.productPrice', true);
    },

    savePrice: function(cmp, evt, helper, action) {
        var action = cmp.get('c.saveProductPrice');
        action.setParams({
            productId: cmp.get('v.recordId'),
            productPrice: parseFloat(cmp.find('enter-product-price').get('v.value'))
        });
        helper.saveProductDetails(cmp, evt, action);
        // helper.closeModal(cmp, evt);
        var closeModalAttribute = false;
        var parentCmp = cmp.get('v.parent');
        parentCmp.closeModalEvent(closeModalAttribute);
    },

    handleLikeButtonClick: function(cmp, event) {
        var photoId = event.currentTarget.dataset.value;
        var photoIndex = event.currentTarget.dataset.index;
        var listAfterDelete = cmp.get('v.photoList');
        listAfterDelete.splice(photoIndex, 1);
        cmp.set('v.photoList', listAfterDelete);
        var action = cmp.get('c.deletePhotoById');
        action.setParams({ photoId: photoId });
        $A.enqueueAction(action);
    },

    setToDisplayUrl: function(cmp, event) {
        var contentDocumentId = event.currentTarget.dataset.param;
        var contentProductId = event.currentTarget.dataset.productid;
        const link = 'https://britenet93-dev-ed.my.salesforce.com/sfc/servlet.shepherd/document/download/' + contentDocumentId;
        var action = cmp.get('c.setDefaultPhotoUrl');
        action.setParams({ productId: contentProductId, link: link });
        action.setCallback(cmp,
            function(response) {
                var state = response.getState();
                if (state === 'SUCCESS') {} else {}
            }
        );
        $A.enqueueAction(action);
    }
})
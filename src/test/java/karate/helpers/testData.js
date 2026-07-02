function fn() {
    var timestamp = new Date().getTime();

    return {
        adminUser:{
            nome: 'QA Admin Test',
            email: 'admin_' + timestamp + '@qa.com',
            password: 'teste123',
            administrador: 'true'
        },

        normalUser:{
            nome: 'QA User Test',
            email: 'user_' + timestamp + '@qa.com',
            password: 'teste123',
            administrador: 'false'
        },

        existingEmailUser:{
            nome: 'Fulano Beltrano',
            email: 'fulano@qa.com',
            password: 'teste',
            administrador: 'true'
        },

        updatedUser:{
            nome: 'QA User Updated',
            email: 'updated_' + timestamp + '@qa.com',
            password: 'newPass123',
            administrador: 'false'
        },

        noExistentId: 'idInexistente000'
    };
}
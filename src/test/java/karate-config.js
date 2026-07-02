function fn() {
    var env = karate.env;
    karate.log('karate.env system property was:', env);

    if(!env){
        env='dev'
    }

    var config = {
        env: env,
        baseUrl: 'https://serverest.dev'
    }

    if (env == 'dev') {
        config.baseUrl = 'https://serverest.dev'
    } else if (env == 'cert' || env == 'qa') {
        config.baseUrl = 'https://serverest.dev'
    }


    karate.configure('connectTimeout', 5000);
    karate.configure('readTimeout', 5000);

    return config;
}
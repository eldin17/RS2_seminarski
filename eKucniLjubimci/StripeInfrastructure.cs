using eKucniLjubimci.Services.InterfaceImplementations;
using eKucniLjubimci.Services.Interfaces;
using Stripe;

namespace eKucniLjubimci
{
    public static class StripeInfrastructure
    {
        public static IServiceCollection AddStripeInfrastructure(this IServiceCollection services, IConfiguration configuration)
        {
            StripeConfiguration.ApiKey = configuration.GetValue<string>("StripeSettings:SecretKey");

            return services
                .AddScoped<CustomerService>()
                .AddScoped<ChargeService>()
                .AddScoped<TokenService>();
        }
    }
}

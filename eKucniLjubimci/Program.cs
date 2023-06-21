using eKucniLjubimci;
using eKucniLjubimci.Services.ArtikalStateMachine;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.InterfaceImplementations;
using eKucniLjubimci.Services.Interfaces;
using eKucniLjubimci.Services.NarudzbaStateMachine;
using eKucniLjubimci.Services.ZivotinjaStateMachine;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.Filters;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddTransient<IOsobaService, OsobaService>();
builder.Services.AddTransient<IKupacService, KupacService>();
builder.Services.AddTransient<ILokacijaService, LokacijaService>();
builder.Services.AddTransient<INarudzbaService, NarudzbaService>();
builder.Services.AddTransient<IArtikalService, ArtikalService>();
builder.Services.AddTransient<IKategorijaService, KategorijaService>();
builder.Services.AddTransient<INovostiService, NovostService>();
builder.Services.AddTransient<IProdavacService, ProdavacService>();
builder.Services.AddTransient<IVrstaService, VrstaService>();
builder.Services.AddTransient<IZivotinjaService, ZivotinjaService>();
builder.Services.AddTransient<IUlogaService, UlogaService>();

builder.Services.AddTransient<BaseNarudzbaState>();
builder.Services.AddTransient<InitialNarudzbaState>();
builder.Services.AddTransient<DraftNarudzbaState>();
builder.Services.AddTransient<ActiveNarudzbaState>();
builder.Services.AddTransient<DoneNarudzbaState>();
builder.Services.AddTransient<DeletedNarudzbaState>();

builder.Services.AddTransient<BaseZivotinjaState>();
builder.Services.AddTransient<InitialZivotinjaState>();
builder.Services.AddTransient<DraftZivotinjaState>();
builder.Services.AddTransient<ActiveZivotinjaState>();
builder.Services.AddTransient<ReservedZivotinjaState>();
builder.Services.AddTransient<SoldZivotinjaState>();
builder.Services.AddTransient<DeletedZivotinjaState>();

builder.Services.AddTransient<BaseArtikalState>();
builder.Services.AddTransient<InitialArtikalState>();
builder.Services.AddTransient<DraftArtikalState>();
builder.Services.AddTransient<ActiveArtikalState>();
builder.Services.AddTransient<DeletedArtikalState>();

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition("oauth2", new OpenApiSecurityScheme
    {
        Description = "Opis - Swagger Authorization header -> (\"Bearer {token}\")",
        In = ParameterLocation.Header,
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey
    });
    options.OperationFilter<SecurityRequirementsOperationFilter>();
});

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(
                    builder.Configuration.GetSection("AppSettings:Token").Value)),
            ValidateIssuer = false,
            ValidateAudience = false
        };
    });

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<DataContext>(options => options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(IOsobaService));

builder.Services.AddStripeInfrastructure(builder.Configuration);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}



app.UseStaticFiles();

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<DataContext>();   

    dataContext.Database.Migrate();
}

app.Run();

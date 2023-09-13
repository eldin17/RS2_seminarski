using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eKucniLjubimci.Services.Migrations
{
    /// <inheritdoc />
    public partial class init : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Kategorije",
                columns: table => new
                {
                    KategorijaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Kategorije", x => x.KategorijaId);
                });

            migrationBuilder.CreateTable(
                name: "Lokacije",
                columns: table => new
                {
                    LokacijaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Drzava = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Grad = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Ulica = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Lokacije", x => x.LokacijaId);
                });

            migrationBuilder.CreateTable(
                name: "Osobe",
                columns: table => new
                {
                    OsobaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumRodjenja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Osobe", x => x.OsobaId);
                });

            migrationBuilder.CreateTable(
                name: "Rase",
                columns: table => new
                {
                    RasaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Rase", x => x.RasaId);
                });

            migrationBuilder.CreateTable(
                name: "Uloge",
                columns: table => new
                {
                    UlogaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Uloge", x => x.UlogaId);
                });

            migrationBuilder.CreateTable(
                name: "Artikli",
                columns: table => new
                {
                    ArtikalId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Cijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Dostupnost = table.Column<bool>(type: "bit", nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    StateMachine = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    KategorijaId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Artikli", x => x.ArtikalId);
                    table.ForeignKey(
                        name: "FK_Artikli_Kategorije_KategorijaId",
                        column: x => x.KategorijaId,
                        principalTable: "Kategorije",
                        principalColumn: "KategorijaId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Vrste",
                columns: table => new
                {
                    VrstaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Boja = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Starost = table.Column<int>(type: "int", nullable: false),
                    Prostor = table.Column<bool>(type: "bit", nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RasaId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Vrste", x => x.VrstaId);
                    table.ForeignKey(
                        name: "FK_Vrste_Rase_RasaId",
                        column: x => x.RasaId,
                        principalTable: "Rase",
                        principalColumn: "RasaId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "KorisnickiNalozi",
                columns: table => new
                {
                    KorisnickiNalogId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Username = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordHash = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    PasswordSalt = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    DatumRegistracije = table.Column<DateTime>(type: "datetime2", nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: false),
                    UlogaId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KorisnickiNalozi", x => x.KorisnickiNalogId);
                    table.ForeignKey(
                        name: "FK_KorisnickiNalozi_Uloge_UlogaId",
                        column: x => x.UlogaId,
                        principalTable: "Uloge",
                        principalColumn: "UlogaId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Kupci",
                columns: table => new
                {
                    KupacId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    BrojNarudzbi = table.Column<int>(type: "int", nullable: false),
                    Kuca = table.Column<bool>(type: "bit", nullable: false),
                    Dvoriste = table.Column<bool>(type: "bit", nullable: false),
                    Stan = table.Column<bool>(type: "bit", nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: false),
                    OsobaId = table.Column<int>(type: "int", nullable: false),
                    LokacijaId = table.Column<int>(type: "int", nullable: false),
                    SlikaKupca = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    KorisnickiNalogId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Kupci", x => x.KupacId);
                    table.ForeignKey(
                        name: "FK_Kupci_KorisnickiNalozi_KorisnickiNalogId",
                        column: x => x.KorisnickiNalogId,
                        principalTable: "KorisnickiNalozi",
                        principalColumn: "KorisnickiNalogId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Kupci_Lokacije_LokacijaId",
                        column: x => x.LokacijaId,
                        principalTable: "Lokacije",
                        principalColumn: "LokacijaId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Kupci_Osobe_OsobaId",
                        column: x => x.OsobaId,
                        principalTable: "Osobe",
                        principalColumn: "OsobaId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Prodavci",
                columns: table => new
                {
                    ProdavacId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PoslovnaJedinica = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: false),
                    SlikaProdavca = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OsobaId = table.Column<int>(type: "int", nullable: false),
                    KorisnickiNalogId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Prodavci", x => x.ProdavacId);
                    table.ForeignKey(
                        name: "FK_Prodavci_KorisnickiNalozi_KorisnickiNalogId",
                        column: x => x.KorisnickiNalogId,
                        principalTable: "KorisnickiNalozi",
                        principalColumn: "KorisnickiNalogId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Prodavci_Osobe_OsobaId",
                        column: x => x.OsobaId,
                        principalTable: "Osobe",
                        principalColumn: "OsobaId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Narudzbe",
                columns: table => new
                {
                    NarudzbaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DatumNarudzbe = table.Column<DateTime>(type: "datetime2", nullable: false),
                    TotalFinal = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    StateMachine = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    KupacId = table.Column<int>(type: "int", nullable: false),
                    PaymentId = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PaymentIntent = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Narudzbe", x => x.NarudzbaId);
                    table.ForeignKey(
                        name: "FK_Narudzbe_Kupci_KupacId",
                        column: x => x.KupacId,
                        principalTable: "Kupci",
                        principalColumn: "KupacId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Novosti",
                columns: table => new
                {
                    NovostId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumPostavljanja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: false),
                    ProdavacId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Novosti", x => x.NovostId);
                    table.ForeignKey(
                        name: "FK_Novosti_Prodavci_ProdavacId",
                        column: x => x.ProdavacId,
                        principalTable: "Prodavci",
                        principalColumn: "ProdavacId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "NarudzbeArtikli",
                columns: table => new
                {
                    NarudzbaArtikalId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NarudzbaId = table.Column<int>(type: "int", nullable: false),
                    ArtikalId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NarudzbeArtikli", x => x.NarudzbaArtikalId);
                    table.ForeignKey(
                        name: "FK_NarudzbeArtikli_Artikli_ArtikalId",
                        column: x => x.ArtikalId,
                        principalTable: "Artikli",
                        principalColumn: "ArtikalId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_NarudzbeArtikli_Narudzbe_NarudzbaId",
                        column: x => x.NarudzbaId,
                        principalTable: "Narudzbe",
                        principalColumn: "NarudzbaId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Zivotinje",
                columns: table => new
                {
                    ZivotinjaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Napomena = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Cijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Dostupnost = table.Column<bool>(type: "bit", nullable: false),
                    DatumPostavljanja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    StateMachine = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NarudzbaId = table.Column<int>(type: "int", nullable: true),
                    VrstaId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Zivotinje", x => x.ZivotinjaId);
                    table.ForeignKey(
                        name: "FK_Zivotinje_Narudzbe_NarudzbaId",
                        column: x => x.NarudzbaId,
                        principalTable: "Narudzbe",
                        principalColumn: "NarudzbaId");
                    table.ForeignKey(
                        name: "FK_Zivotinje_Vrste_VrstaId",
                        column: x => x.VrstaId,
                        principalTable: "Vrste",
                        principalColumn: "VrstaId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Slike",
                columns: table => new
                {
                    SlikaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Putanja = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    isDeleted = table.Column<bool>(type: "bit", nullable: false),
                    ArtikalId = table.Column<int>(type: "int", nullable: true),
                    ZivotinjaId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Slike", x => x.SlikaId);
                    table.ForeignKey(
                        name: "FK_Slike_Artikli_ArtikalId",
                        column: x => x.ArtikalId,
                        principalTable: "Artikli",
                        principalColumn: "ArtikalId");
                    table.ForeignKey(
                        name: "FK_Slike_Zivotinje_ZivotinjaId",
                        column: x => x.ZivotinjaId,
                        principalTable: "Zivotinje",
                        principalColumn: "ZivotinjaId");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Artikli_KategorijaId",
                table: "Artikli",
                column: "KategorijaId");

            migrationBuilder.CreateIndex(
                name: "IX_KorisnickiNalozi_UlogaId",
                table: "KorisnickiNalozi",
                column: "UlogaId");

            migrationBuilder.CreateIndex(
                name: "IX_Kupci_KorisnickiNalogId",
                table: "Kupci",
                column: "KorisnickiNalogId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Kupci_LokacijaId",
                table: "Kupci",
                column: "LokacijaId");

            migrationBuilder.CreateIndex(
                name: "IX_Kupci_OsobaId",
                table: "Kupci",
                column: "OsobaId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Narudzbe_KupacId",
                table: "Narudzbe",
                column: "KupacId");

            migrationBuilder.CreateIndex(
                name: "IX_NarudzbeArtikli_ArtikalId",
                table: "NarudzbeArtikli",
                column: "ArtikalId");

            migrationBuilder.CreateIndex(
                name: "IX_NarudzbeArtikli_NarudzbaId",
                table: "NarudzbeArtikli",
                column: "NarudzbaId");

            migrationBuilder.CreateIndex(
                name: "IX_Novosti_ProdavacId",
                table: "Novosti",
                column: "ProdavacId");

            migrationBuilder.CreateIndex(
                name: "IX_Prodavci_KorisnickiNalogId",
                table: "Prodavci",
                column: "KorisnickiNalogId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Prodavci_OsobaId",
                table: "Prodavci",
                column: "OsobaId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Slike_ArtikalId",
                table: "Slike",
                column: "ArtikalId");

            migrationBuilder.CreateIndex(
                name: "IX_Slike_ZivotinjaId",
                table: "Slike",
                column: "ZivotinjaId");

            migrationBuilder.CreateIndex(
                name: "IX_Vrste_RasaId",
                table: "Vrste",
                column: "RasaId");

            migrationBuilder.CreateIndex(
                name: "IX_Zivotinje_NarudzbaId",
                table: "Zivotinje",
                column: "NarudzbaId");

            migrationBuilder.CreateIndex(
                name: "IX_Zivotinje_VrstaId",
                table: "Zivotinje",
                column: "VrstaId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "NarudzbeArtikli");

            migrationBuilder.DropTable(
                name: "Novosti");

            migrationBuilder.DropTable(
                name: "Slike");

            migrationBuilder.DropTable(
                name: "Prodavci");

            migrationBuilder.DropTable(
                name: "Artikli");

            migrationBuilder.DropTable(
                name: "Zivotinje");

            migrationBuilder.DropTable(
                name: "Kategorije");

            migrationBuilder.DropTable(
                name: "Narudzbe");

            migrationBuilder.DropTable(
                name: "Vrste");

            migrationBuilder.DropTable(
                name: "Kupci");

            migrationBuilder.DropTable(
                name: "Rase");

            migrationBuilder.DropTable(
                name: "KorisnickiNalozi");

            migrationBuilder.DropTable(
                name: "Lokacije");

            migrationBuilder.DropTable(
                name: "Osobe");

            migrationBuilder.DropTable(
                name: "Uloge");
        }
    }
}

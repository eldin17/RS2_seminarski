using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eKucniLjubimci.Services.Migrations
{
    /// <inheritdoc />
    public partial class seed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Kategorije",
                columns: new[] { "KategorijaId", "Naziv", "isDeleted" },
                values: new object[,]
                {
                    { 1, "Hrana",false },
                    { 2, "Kucice",false },
                    { 3, "Igracke",false },
                });
            migrationBuilder.InsertData(
                table: "Artikli",
                columns: new[] { "ArtikalId", "Naziv", "Cijena", "Dostupnost", "Opis", "StateMachine", "KategorijaId" },
                values: new object[,]
                {
                    { 1, "Hrana za pse premium",200m,true,"Predstavljamo našu vrhunsku hranu za pse. Napravljena s kvalitetnim sastojcima, pruža ravnotežnu prehranu i okus koji psi obožavaju. Pružite svom psu najbolje s našom hranom.","Draft",1},
                    { 2, "Hrana za pse standard",150m,true,"Isprobajte našu vrhunsku hranu za pse. Sastavljena od visokokvalitetnih sastojaka, naša hrana pruža uravnoteženu prehranu za zdravlje vašeg psa. Osigurajte da vaš ljubimac dobiva najbolje s našom hranom.","Active",1 },
                    { 3, "Hrana za pse",100m,true,"Uživajte u našoj vrhunskoj hrani za pse. Sa pažljivo odabranim sastojcima, naša hrana pruža ukusnu i hranjivu prehranu za vašeg psa. Neka vaš ljubimac uživa u najboljem obroku svaki dan.","Active",1},
                    { 4, "Hrana za macke premium",200m,true,"Isprobajte našu vrhunsku hranu za mačke. Napravljena s pažljivo odabranim sastojcima, pruža izvrsnu prehranu i okus koji mačke obožavaju. Obezbijedite najbolju prehranu za vašu mačku s našom hranom.", "Draft",1},
                    { 5, "Hrana za macke standard",150m,true,"Upoznajte našu premium hranu za mačke. Sa visokokvalitetnim sastojcima, pruža uravnoteženu prehranu za zdravlje i vitalnost vaše mačke. Neka vaša mačka uživa u svakom zalogaju naše ukusne hrane.", "Active",1},
                    { 6, "Hrana za macke",100m,true,"Osigurajte najbolju prehranu za svoju mačku s našim proizvodima. Hranimo vašu mačku s kvalitetnom hranom koja sadrži sve potrebne hranjive tvari. Neka vaša mačka bude zdrava i sretna uz našu hranu.", "Active",1 },
                    { 7, "Hrana za ptice premium",100m,true,"Upoznajte našu visokokvalitetnu hranu za ptice. Pažljivo kreirana kako bi pružila hranjivu i ukusnu prehranu za vaše pernate prijatelje. Obezbijedite svojim pticama vrhunsku prehranu koja će podržati njihovo zdravlje i vitalnost.","Draft",1 },
                    { 8, "Hrana za ptice standard",50m,true,"Istražite našu široku ponudu hrane za ptice koja zadovoljava potrebe različitih vrsta. Bez obzira imate li papagaja, kanarinca ili druge vrste ptica, naša hrana će pružiti uravnoteženu prehranu s bogatim izvorima vitamina i minerala. Osigurajte da vaše ptice uživaju u visokokvalitetnoj i ukusnoj hrani koja će ih oduševiti.", "Active",1},
                    { 9, "Hrana za ptice",25m,true,"Pružite svojim pernatim prijateljima najbolju prehranu s našom specijaliziranom hranom za ptice. Sa pažljivo odabranim sastojcima, naša hrana pruža optimalnu prehranu koja potiče vitalnost, boje perja i cjelokupno zdravlje ptica. Neka vaše ptice budu zdrave i sretne uz našu vrhunsku hranu.", "Active",1},
                    { 10, "Kucica za pse premium",300m,true,"Osigurajte udoban dom za svog psa s našim vrhunskim psim kućicama. Izrađene od izdržljivih materijala, naše kućice pružaju zaštitu od vremenskih uvjeta i udobnost vašem psu. Odaberite kućicu koja će savršeno odgovarati potrebama i veličini vašeg ljubimca.","Active",2},
                    { 11, "Kucica za pse standard",250m,true,"Neka vaš pas uživa u udobnosti i sigurnosti naših kvalitetnih psih kućica. Sa izoliranim materijalima i dobro dizajniranom strukturom, naše kućice pružaju toplinu i zaštitu od hladnoće, vrućine i kiše. Stvorite savršeno mjesto za odmor i spavanje za svog psa.","Active",2},
                    { 12, "Kucica za macke premium",300m,true,"Izaberite savršen dom za svoju mačku iz naše raznolike ponude mačjih kućica. Bilo da je to prostrana i luksuzna kućica ili kompaktna i praktična opcija, naše kućice pružaju udobnost i sigurnost vašoj mački. Osigurajte da vaša mačka ima svoj miran kutak za opuštanje i spavanje.","Active",2},
                    { 13, "Kucica za macke standard",250m,true,"Osigurajte udoban dom za svoju mačku s našim vrhunskim mačjim kućicama. Izrađene od kvalitetnih materijala, naše kućice pružaju sigurnost i udobnost vašoj mački. Odaberite kućicu koja će pružiti toplinu i zaštitu vašem ljubimcu.","Active",2},
                    { 14, "Kavez za ptice standard",50m,true,"Osigurajte siguran dom za vaše pernate prijatelje s našim vrhunskim kavezima za ptice. Izrađeni od čvrstih materijala, naši kavezi pružaju prostran prostor za letenje i udobno gnijezdo za vaše ptice. Odaberite kavez koji će zadovoljiti potrebe vaših pernatih ljubimaca i pružiti im sigurnost.","Active",2},
                    { 15, "Kavez za ptice",25m,true,"Uživajte u promatranju i brizi za ptice uz naše kvalitetne kaveze. Sa čvrstom konstrukcijom i sigurnosnim značajkama, naši kavezi pružaju zaštićeno okruženje za vaše pernate prijatelje. Opremite svoj dom s kavezom koji će istovremeno zadovoljiti potrebe ptica i biti estetski privlačan dodatak vašem prostoru.","Active",2},
                    { 16, "Igracka za pse premium",25m,true,"Osnažite vezu s vašim psom i podstaknite njegovu inteligenciju s našim raznovrsnim izborom igračaka. Od interaktivnih zagonetki do plišanih igračaka, naše igračke pružaju psima mentalnu stimulaciju i emocionalno zadovoljstvo. Opremite svog ljubimca s najboljim igračkama i stvorite trenutke radosti i zabave zajedno.","Active",3},
                    { 17, "Igracka za pse",10m,true,"Razveselite svog psa i pružite mu neodoljivu zabavu s našim kvalitetnim igračkama za pse. Izrađene od izdržljivih materijala, naše igračke su dizajnirane da izdrže sate žestoke igre i žvakanja. Odaberite igračku koja će održavati vašeg psa sretnim, zdravim i aktivnim.","Active",3},
                    { 18, "Igracka za macke premium",25m,true,"Uveselite vašu mačku i pružite joj neodoljivu zabavu s našim kvalitetnim igračkama za mačke. Bez obzira želi li se igrati lopticama, penjati se na visećim spravama ili loviti mačje štapove, naše igračke pružaju satove neprestane zabave i aktivnosti. Odaberite igračku koja će držati vašu mačku aktivnom, zadovoljnom i okupiranom.","Active",3},
                    { 19, "Igracka za macke",10m,true,"Potaknite instinkte vaše mačke i oživite njenu igru s našim raznolikim izborom igračaka. Od pernatih loptica do miševa na žici, naše igračke pružaju mačkama zabavu i mogućnost vježbanja. Opremite svoj dom s najboljim mačjim igračkama i stvorite trenutke radosti i igre s vašim ljubimcem.","Active",3},
                    { 20, "Igracka za ptice premium",25m,true,"Razveselite svoje pernate prijatelje i obogatite njihovu svakodnevicu s našim kvalitetnim igračkama za ptice. Od ljuljački i visećih sprava do zvučnih igračaka, naše igračke pružaju pticama mentalnu stimulaciju, vježbu i zabavu. Odaberite igračku koja će upotpuniti okoliš vaših ptica i osigurati im satove neprestane igre.","Active",3},
                    { 21, "Igracka za ptice",10m,true,"Potaknite prirodno ponašanje i istraživački duh vaših ptica s našim raznovrsnim izborom igračaka. Sa zvečkama, ogledalima i visećim gumicama, naše igračke će pružiti vašim pticama neograničenu zabavu i aktivnost. Opremite svoj prostor s najboljim igračkama za ptice i uživajte u promatranju njihove sreće i igre.","Active",3},
                });

            migrationBuilder.InsertData(
                table: "Uloge",
                columns: new[] { "UlogaId", "Naziv" },
                values: new object[,]
                {
                    { 1, "Prodavac" },
                    { 2, "Kupac" }
                });

            migrationBuilder.InsertData(
                table: "KorisnickiNalozi",
                columns: new[] { "KorisnickiNalogId", "Username", "PasswordHash", "PasswordSalt", "DatumRegistracije", "UlogaId", "isDeleted" },
                values: new object[,]
                {
                    { 1, "korisnik1",
                        new byte[]
                        {
                            0xDB, 0x62, 0x34, 0x30, 0x99, 0xC2, 0x01, 0xB9, 0x82, 0x04, 0xF8, 0x55, 0x32, 0xA9, 0x9B, 0x15,
                            0x24, 0x8C, 0xEF, 0x13, 0xB7, 0x3E, 0x3D, 0xBE, 0xF4, 0xD1, 0xCC, 0x6F, 0x49, 0x63, 0xD6, 0x10,
                            0xB7, 0x02, 0xA6, 0x97, 0x01, 0xE4, 0x03, 0x7A, 0x0B, 0x2E, 0x11, 0x83, 0xA5, 0x7E, 0x7C, 0x04,
                            0x5A, 0x59, 0x82, 0xBA, 0x3A, 0x8F, 0xD2, 0x48, 0x11, 0x40, 0x0E, 0x95, 0x6D, 0x81, 0x15, 0x6F
                        },
                        new byte[]
                        {
                            0x93, 0x3F, 0x01, 0xFD, 0x36, 0x10, 0xD9, 0x4E, 0x93, 0x07, 0x48, 0xB4, 0xFF, 0x0E, 0x33, 0x70,
                            0x0A, 0x53, 0xB6, 0x5B, 0x2A, 0x1C, 0xA0, 0xD8, 0x60, 0x9D, 0x4C, 0x85, 0xDA, 0x05, 0x97, 0x63,
                            0xC5, 0x89, 0x5B, 0xCF, 0x48, 0xCF, 0x90, 0x84, 0x24, 0x63, 0x1E, 0x98, 0x42, 0xDA, 0x2D, 0x9E,
                            0xD0, 0xCD, 0x50, 0xCA, 0x9E, 0x28, 0x1A, 0x2C, 0xED, 0xBF, 0xAE, 0xC2, 0xE9, 0x6F, 0x22, 0x7D,
                            0xEC, 0xAE, 0xFB, 0xD0, 0xCF, 0x6E, 0xF4, 0x54, 0x06, 0x26, 0xB8, 0xAE, 0xDA, 0x6A, 0x89, 0xFD,
                            0xF5, 0xB7, 0x78, 0x33, 0x35, 0xE4, 0xCD, 0x6F, 0x96, 0xBB, 0xA0, 0xF9, 0x2E, 0x12, 0xF1, 0x9D,
                            0x65, 0x3A, 0x4F, 0x98, 0xD4, 0x19, 0x77, 0xBF, 0xAB, 0x23, 0x18, 0xA2, 0x45, 0x6C, 0xDE, 0x43,
                            0xD2, 0x14, 0x8A, 0x1A, 0x42, 0xCD, 0x78, 0x99, 0x28, 0x71, 0x90, 0x95, 0xCB, 0x9B, 0x1F, 0xA6
                        },
                        DateTime.UtcNow.AddMonths(-2),1,false },
                    { 2, "korisnik2",
                        new byte[]
                        {
                            0x02, 0xEA, 0x2A, 0x7F, 0xD9, 0x27, 0x52, 0x9B, 0xC9, 0x57, 0x09, 0x8A, 0x3E, 0xEA, 0xD7, 0x58,
                            0x9D, 0x96, 0xC2, 0xA3, 0xA1, 0x3C, 0x72, 0x27, 0xA3, 0x2C, 0x2D, 0x6F, 0x4E, 0xC5, 0x23, 0x24,
                            0xF9, 0x7D, 0x25, 0xE8, 0x82, 0xA5, 0xD6, 0x72, 0x09, 0xAF, 0xD2, 0x13, 0x6D, 0x44, 0xF8, 0xA0,
                            0x19, 0x8C, 0x8F, 0x74, 0xC5, 0x05, 0x35, 0xB2, 0x81, 0x2D, 0xF8, 0x2B, 0x3B, 0x3F, 0x4A, 0xF6
                        },
                        new byte[]
                        {
                            0x31, 0xCF, 0x08, 0xF3, 0x64, 0x43, 0x7F, 0xB6, 0x07, 0xB3, 0x73, 0x22, 0x4A, 0x76, 0xF3, 0xB7,
                            0x12, 0x3A, 0x1E, 0xC1, 0xED, 0x7A, 0x55, 0x29, 0x4F, 0xDE, 0xBC, 0x64, 0xFB, 0x76, 0x75, 0x20,
                            0xB8, 0xDE, 0x43, 0x43, 0xC5, 0x8D, 0x34, 0x66, 0x33, 0x78, 0x6D, 0xB5, 0x68, 0xE1, 0xBA, 0xE7,
                            0xF4, 0x99, 0x79, 0x19, 0xD2, 0xD0, 0xD4, 0xE6, 0x16, 0xD1, 0x4C, 0x49, 0x16, 0xE1, 0xAF, 0xB9,
                            0xC5, 0xFD, 0xFD, 0x2C, 0x5E, 0xC8, 0x90, 0x2C, 0x09, 0xD7, 0xDE, 0xDC, 0xD5, 0x8A, 0x1C, 0x84,
                            0xEC, 0x5E, 0xAA, 0x0E, 0x63, 0x9C, 0xAA, 0xA9, 0xB7, 0xE2, 0xA0, 0x23, 0x6B, 0xBF, 0x3E, 0x7A,
                            0x54, 0xCA, 0x7E, 0x28, 0xBD, 0xE2, 0x08, 0x20, 0x7D, 0xFB, 0x91, 0x89, 0xD5, 0x98, 0xBF, 0xAE,
                            0x7F, 0x0C, 0x8C, 0x79, 0xF2, 0x2C, 0x9A, 0x8F, 0xDF, 0x47, 0x61, 0x11, 0xE0, 0x04, 0xC9, 0x9D
                        },
                        DateTime.UtcNow.AddMonths(-3),1,false },
                    { 3, "korisnik3",
                        new byte[]
                        {
                            0x1C, 0x26, 0x74, 0x95, 0x39, 0xA6, 0xDA, 0x2F, 0x15, 0xCD, 0xD3, 0x49, 0xAA, 0x8A, 0xB3, 0xB8,
                            0x87, 0x65, 0xC4, 0xAD, 0x32, 0x70, 0x89, 0xA4, 0xF5, 0x96, 0x58, 0x61, 0x37, 0x36, 0x6A, 0x86,
                            0xCF, 0xBD, 0x0B, 0x80, 0x9E, 0x02, 0x11, 0x97, 0x62, 0xCA, 0xBE, 0x5C, 0xF5, 0xFB, 0xAA, 0xF2,
                            0x49, 0x00, 0x05, 0xBE, 0x63, 0xCD, 0x86, 0xA2, 0x11, 0x16, 0xFC, 0x1B, 0x54, 0x32, 0x5D, 0x33
                        },
                        new byte[]
                        {
                            0x8F, 0x7C, 0xE0, 0x00, 0x17, 0x50, 0xD8, 0xA6, 0xE7, 0x83, 0x23, 0xA6, 0xE5, 0x68, 0xE2, 0x54,
                            0x8F, 0xE1, 0xA6, 0x59, 0xD0, 0x65, 0xCA, 0x0E, 0xE6, 0x2C, 0x2A, 0xE5, 0xC6, 0xDC, 0x47, 0x96,
                            0x01, 0x38, 0xC5, 0x08, 0xB7, 0x1D, 0x3D, 0xA6, 0x1A, 0x47, 0x29, 0x74, 0xAA, 0xC3, 0x84, 0x96,
                            0x0E, 0x86, 0x6D, 0x73, 0x17, 0x8D, 0x02, 0x1A, 0x0E, 0x0A, 0x3A, 0x09, 0x42, 0x3A, 0xC6, 0x77,
                            0xC6, 0x76, 0xF9, 0x78, 0xB8, 0x9A, 0xAD, 0x15, 0xA0, 0x71, 0xF0, 0x55, 0xB2, 0xDA, 0x08, 0x7D,
                            0x52, 0x23, 0x38, 0x9E, 0x74, 0x41, 0x66, 0x72, 0x1F, 0x2F, 0x92, 0x6D, 0xF1, 0x4D, 0x1C, 0x4D,
                            0x59, 0x45, 0xFE, 0x36, 0xA7, 0x6D, 0x33, 0x86, 0xF8, 0xBB, 0x17, 0xD0, 0x87, 0x38, 0xD8, 0x02,
                            0x2C, 0x06, 0xC4, 0x71, 0x74, 0xA9, 0xFB, 0x89, 0x23, 0xB8, 0xD3, 0xC9, 0xF7, 0xF5, 0x4B, 0x70
                        },
                        DateTime.UtcNow.AddMonths(-1),2,false },
                    { 4, "korisnik4",
                        new byte[]
                        {
                            0x2D, 0x73, 0x60, 0xFA, 0xF3, 0x4F, 0x12, 0x86, 0x03, 0xAE, 0xC2, 0x92, 0x17, 0x72, 0x5C, 0xC3,
                            0x52, 0xC8, 0x4E, 0x3D, 0x29, 0x88, 0x90, 0x1F, 0xB8, 0x62, 0x81, 0x58, 0xB0, 0x1F, 0xEC, 0xC3,
                            0x45, 0xFF, 0x76, 0xEC, 0x2F, 0x14, 0x2B, 0xD9, 0x05, 0x85, 0xF8, 0x40, 0x42, 0x51, 0xE5, 0xA7,
                            0xE9, 0xA7, 0x34, 0x75, 0x8F, 0x86, 0x47, 0xA3, 0x5B, 0x4F, 0xD9, 0x1B, 0xBA, 0xD2, 0x10, 0x1C
                        },
                        new byte[]
                        {
                            0xB9, 0xC1, 0x73, 0x0D, 0x07, 0xDF, 0xF2, 0x71, 0x40, 0xAF, 0xFC, 0x27, 0x70, 0xBC, 0x47, 0x8F,
                            0xFF, 0xA8, 0x5B, 0x52, 0x1B, 0xC7, 0x49, 0x3D, 0xDF, 0x79, 0xC9, 0xE1, 0x5A, 0x5C, 0x59, 0x73,
                            0xE9, 0xA2, 0x6A, 0x9C, 0x10, 0xFF, 0x30, 0xE3, 0x5D, 0x12, 0x64, 0x97, 0x8C, 0x21, 0x88, 0x38,
                            0xB9, 0x7D, 0x1A, 0x3F, 0xE7, 0x15, 0xFE, 0xCA, 0x12, 0xB3, 0xF7, 0xD5, 0x60, 0xB5, 0x31, 0x03,
                            0x85, 0xBD, 0xD4, 0x95, 0xF5, 0xEA, 0x02, 0x8B, 0x20, 0x1C, 0x8B, 0xD6, 0xD4, 0x8B, 0x7B, 0x15,
                            0x6A, 0xF6, 0x56, 0xE9, 0xE4, 0xD3, 0x70, 0x70, 0x6D, 0x33, 0x9A, 0x23, 0xC3, 0xE6, 0xC3, 0x1A,
                            0xB1, 0xD9, 0xC5, 0xFB, 0x80, 0x4B, 0x6F, 0xEF, 0x6F, 0xC5, 0x86, 0x9D, 0x56, 0x88, 0x93, 0x71,
                            0x7C, 0xC6, 0xBE, 0x91, 0x83, 0x98, 0x48, 0xFB, 0xA2, 0x52, 0xE1, 0x97, 0x2F, 0x3F, 0xEE, 0x0C
                        },
                        DateTime.UtcNow.AddMonths(-1),2,false },
                    { 5, "desktop",
                        new byte[]
                        {
                            0xF9, 0x45, 0xA9, 0xDD, 0x0A, 0xFB, 0xF0, 0x8C, 0x05, 0x7F, 0x36, 0xE3, 0xA4, 0x87, 0x1A, 0x82,
                            0x38, 0xEC, 0x41, 0x62, 0xDE, 0xA3, 0x57, 0xF0, 0xC1, 0x37, 0x4C, 0x86, 0xD8, 0xB7, 0x7B, 0xA7,
                            0xB4, 0xD0, 0x61, 0xB1, 0xC7, 0x09, 0x87, 0xA3, 0x95, 0xC3, 0x7D, 0x96, 0xFA, 0x6A, 0x90, 0x5E,
                            0x96, 0x64, 0x6D, 0x30, 0x2E, 0xF1, 0x57, 0xF5, 0x43, 0xDB, 0x6A, 0xA5, 0x72, 0x7F, 0x61, 0x00
                        },
                        new byte[]
                        {
                            0x28, 0x7C, 0xFC, 0x33, 0xD4, 0x99, 0xA9, 0xD3, 0xA3, 0x9F, 0xF0, 0x64, 0x1E, 0x02, 0xE8, 0x76,
                            0x25, 0xBE, 0x6E, 0xAE, 0x37, 0x6F, 0x61, 0xFD, 0x7F, 0xC2, 0x28, 0x0B, 0xEE, 0xF5, 0x21, 0xE2,
                            0xBB, 0x98, 0x4F, 0x51, 0x43, 0x48, 0x48, 0x29, 0xC8, 0xC2, 0x5C, 0xC8, 0x70, 0x0D, 0x56, 0xB4,
                            0x11, 0xA6, 0x7B, 0xB1, 0xA6, 0x30, 0x76, 0x9A, 0x06, 0xD1, 0x99, 0x34, 0xBB, 0x53, 0xB1, 0x14,
                            0x72, 0x9F, 0x02, 0x18, 0xA9, 0xCD, 0xA9, 0xB0, 0xA3, 0x9D, 0xF8, 0x8E, 0x24, 0xA7, 0x13, 0x75,
                            0x48, 0x50, 0xC6, 0xD7, 0x4D, 0x58, 0x6C, 0x48, 0xB1, 0xDD, 0x42, 0x89, 0x58, 0x6D, 0x0F, 0x03,
                            0x0C, 0xA0, 0x63, 0xB6, 0x78, 0x98, 0x89, 0xD4, 0x02, 0x86, 0x13, 0x7A, 0xAC, 0xCF, 0x78, 0x56,
                            0xE5, 0x19, 0xD8, 0x78, 0x77, 0xB7, 0x64, 0xEB, 0xCA, 0xB2, 0x19, 0xB5, 0xB4, 0xCC, 0x78, 0xF2
                        },
                        DateTime.UtcNow.AddMonths(-2),1,false },
                    { 6, "mobile",
                        new byte[]
                        {
                            0x13, 0x5F, 0x33, 0x4F, 0xE4, 0x10, 0x63, 0xD3, 0x7D, 0x0D, 0x9F, 0x1E, 0xD6, 0x5D, 0x87, 0xD0,
                            0xB1, 0x78, 0xE5, 0x71, 0x91, 0x34, 0x94, 0x0E, 0xE0, 0x93, 0xD2, 0xC6, 0xAE, 0xB6, 0x3B, 0x18,
                            0xB8, 0x68, 0x3A, 0xF3, 0xCA, 0xA4, 0xCB, 0x81, 0x4C, 0x3A, 0x36, 0x39, 0x21, 0xBC, 0x8A, 0x47,
                            0xF5, 0xA2, 0xD6, 0x41, 0xEC, 0xF6, 0x9F, 0xC2, 0x0B, 0xF7, 0x7D, 0xF0, 0x08, 0xF2, 0x46, 0x28
                        },
                        new byte[]
                        {
                            0x20, 0x32, 0x4B, 0xD5, 0x84, 0x51, 0x0B, 0xE9, 0xFC, 0x6A, 0xF3, 0xBD, 0x4F, 0x02, 0x87, 0xE0,
                            0xB1, 0xB1, 0x0B, 0x2E, 0x74, 0xA1, 0x62, 0xE6, 0x39, 0x5B, 0xF7, 0x4D, 0x8D, 0x56, 0x50, 0xAF,
                            0xAA, 0x4C, 0x79, 0x5F, 0x9E, 0xD2, 0xFD, 0xA6, 0xC2, 0xD5, 0xEE, 0x61, 0x10, 0x6E, 0xA2, 0xBB,
                            0xF2, 0x89, 0x18, 0x89, 0xAD, 0x63, 0x7A, 0x81, 0xC7, 0xA2, 0x6C, 0xC0, 0xE4, 0x8D, 0x15, 0x3F,
                            0x8C, 0x92, 0xA2, 0x01, 0x53, 0x40, 0xC1, 0x9B, 0xD7, 0xC4, 0xEE, 0xAE, 0x1C, 0x8A, 0xB6, 0x7B,
                            0x9C, 0xAC, 0xC1, 0x5D, 0x99, 0x8D, 0x9E, 0x18, 0x69, 0x18, 0xEB, 0x61, 0x64, 0x91, 0x06, 0x8F,
                            0xF0, 0xD0, 0xE6, 0xA7, 0xC8, 0x18, 0x60, 0x13, 0x28, 0x53, 0x1D, 0x66, 0xB3, 0x94, 0xE7, 0x92,
                            0x45, 0x47, 0xA0, 0x83, 0x03, 0xC3, 0x31, 0x96, 0x73, 0xA9, 0xF7, 0x15, 0xD8, 0xE7, 0xC4, 0x4E
                        },
                        DateTime.UtcNow.AddMonths(-3),2,false }
                });

            migrationBuilder.InsertData(
                table: "Lokacije",
                columns: new[] { "LokacijaId", "Drzava", "Grad", "Ulica", "isDeleted" },
                values: new object[,]
                {
                    { 1, "Bosna i Hercegovina","Gorazde","Visegradska",false },
                    { 2, "Bosna i Hercegovina","Sarajevo","Ferhadija",false },
                    { 3, "Bosna i Hercegovina","Mostar","Alekse Santica",false },
                    { 4, "Bosna i Hercegovina","Visegrad","Mehmed-pase Sokolovica",false },
                    { 5, "Bosna i Hercegovina","Bihac","Safeta Zajke",false },
                    { 6, "Bosna i Hercegovina","Konjic","Zijada Beslagica",false },
                });

            migrationBuilder.InsertData(
                table: "Osobe",
                columns: new[] { "OsobaId", "Ime", "Prezime", "DatumRodjenja", "isDeleted" },
                values: new object[,]
                {
                    { 1, "Lejla","Mustafic",DateTime.UtcNow.AddYears(-20),false },
                    { 2, "Lamija","Demirovic",DateTime.UtcNow.AddYears(-30),false },
                    { 3, "Amar","Suljic",DateTime.UtcNow.AddYears(-27),false },
                    { 4, "Mirza","Begic",DateTime.UtcNow.AddYears(-22),false },
                    { 5, "Edin","Demirovic",DateTime.UtcNow.AddYears(-24),false },
                    { 6, "Emir","Hasic",DateTime.UtcNow.AddYears(-25),false },
                });

            migrationBuilder.InsertData(
                table: "Rase",
                columns: new[] { "RasaId", "Naziv" },
                values: new object[,]
                {
                    {1, "Pas"},
                    {2, "Macka"},
                    {3, "Ptica"},
                    {4, "Riba"},
                    {5, "Hrcak"},
                    {6, "Kornjaca"},
                    {7, "Zec"},
                    {8, "Zmija"},
                    {9, "Zamorac"},
                });

            migrationBuilder.InsertData(
                table: "Vrste",
                columns: new[] { "VrstaId", "RasaId", "Naziv", "Opis", "Boja", "Starost", "Prostor", "isDeleted" },
                values: new object[,]
                {
                    { 1, 1,"Sarplaninac","Šarplaninac je pasmina pasa srednje veličine poznata po svojoj hrabrosti, zaštitničkom instinktu i izdržljivosti, te se često koristi kao čuvar stoke i imanja.","Bijela", 4, true,false },
                    { 2, 1,"Labrador","Labrador retriver je pasmina pasa poznata po svojoj privrženosti, inteligenciji i ljubaznom temperamentu, te se često koristi kao radni pas u različitim područjima, uključujući pretragu i spašavanje, terapiju i kao obiteljski ljubimac.","Zlatna",2, true, false },
                    { 3, 1,"Dalmatinac","Dalmatincu je karakteristična prepoznatljiva mrljasta dlaka, energična priroda i prijateljski temperament, te je često povezan s vatrogasnim postrojbama i poznat po svom elegantnom izgledu.","Bijela-Crna",7, true, false },
                    { 4, 2,"Perzijska","Perzijska mačka je prepoznatljiva po svojoj dugoj, bujnoj dlaci, velikim očima i elegantnom izgledu, a poznata je po svojoj mirnoj i umiljatoj naravi.","Bijela", 1,false ,false },
                    { 5, 2,"Abesinska","Abesinska mačka je eleganta i graciozna pasmina, s kratkom smeđom dlakom koja se ističe po svom tigrastom uzorku, a karakterizira je energičnost, znatiželja i ljubav prema igri.","Zlatna", 2, false, false },
                    { 6, 2,"Egipatska","Egipatska mau je drevna pasmina mačaka poznata po svojim karakterističnim mrljama sličnim leopardovima, iznimno je elegantna i brza, te se ističe po svojoj ljupkoj i privrženoj naravi.","Siva", 3, false, false },
                    { 7, 3,"Papagaj","Papagaj je šareno pernato stvorenje s izražajnim kljunom, sposoban za ponavljanje riječi i zvukova, te je popularan kao kućni ljubimac zbog svoje inteligencije i druželjubivosti.","Plava", 1,  false,false },
                    { 8, 3,"Kanarinac","Kanarinac je mali pjevajući ptičji ljubimac s prepoznatljivim živopisnim perjem i slatkim pjevom, često se uzgaja zbog svoje ljepote i melodičnog glasa.","Zuta", 2, false, false },
                    { 9, 3,"Golub","Golub je ptica srednje veličine, poznata po svojoj sposobnosti letenja, vjernosti i izraženom društvenom ponašanju, često se koristi za golubarstvo i kao simbol mira.","Siva", 1,false , false },
                });

            migrationBuilder.InsertData(
                table: "Kupci",
                columns: new[] { "KupacId", "BrojNarudzbi", "Kuca", "Dvoriste", "Stan", "OsobaId", "LokacijaId", "SlikaKupca", "KorisnickiNalogId", "isDeleted" },
                values: new object[,]
                {
                    { 1, 3, true,true,false,1,1,"http://localhost:7152/SlikeKupaca/slika1.jpg",3,false },
                    { 2, 2, false,true,true,2,2,"http://localhost:7152/SlikeKupaca/slika2.jpg",4,false },
                    { 3, 10, false,false,true,3,3,"http://localhost:7152/SlikeKupaca/slika3.jpg",6,false },
                });

            migrationBuilder.InsertData(
               table: "Prodavci",
               columns: new[] { "ProdavacId", "PoslovnaJedinica", "SlikaProdavca", "OsobaId", "KorisnickiNalogId", "isDeleted" },
               values: new object[,]
               {
                    { 1, "Centar","http://localhost:7152/SlikeProdavaca/slika4.jpg",4,1,false },
                    { 2, "Centar","http://localhost:7152/SlikeProdavaca/slika5.jpg",5,2,false },
                    { 3, "Centar","http://localhost:7152/SlikeProdavaca/slika6.jpg",6,5,false },
               });

            migrationBuilder.InsertData(
                table: "Novosti",
                columns: new[] { "NovostId", "Naslov", "Sadrzaj", "DatumPostavljanja", "ProdavacId", "isDeleted" },
                values: new object[,]
                {
                    { 1, "Novo u ponudi!",
                        "Sa zadovoljstvom vas obavještavamo o dolasku preslatke kolekcije \"Vrhunska štenad\" u naš pet shop! Ovi mali paketići radosti traže svoje zauvijek domove. Dođite i upoznajte najslađe štence u gradu, od igrašnih retrivera do šarmantnih buldoga francuza. Naše stručno osoblje će vas voditi kroz proces udomljavanja i pomoći vam pronaći savršenog suputnika.",
                        DateTime.UtcNow.AddDays(-20),1,false },
                    { 2, "Ljubitelji mačaka se raduju",
                        "Pozivamo sve ljubitelje mačaka! Označite svoje kalendare za naš nadolazeći Sajam udomljavanja mačaka koji se održava ovog vikenda. Udružili smo se s lokalnim organizacijama za spašavanje kako bismo vam ponudili raznovrsne mačke koje traže ljubavne obitelji. Bilo da tražite mačku za mazanje ili aktivnog i igračkog suputnika, sigurno ćete pronaći savršenog ljubimca na sajmu. Ne propustite ovu priliku da pružite zauvijek dom zaslužnoj mački!",
                        DateTime.UtcNow.AddDays(-10),1,false },
                    { 3, "Usluge šišanja i njega ljubimaca",
                        "Obradujte svoje ljubimce luksuznim iskustvom šišanja u našem pet shopu. Naši vješti i brižni frizeri će se pobrinuti da vaši krznati prijatelji izgledaju i osjećaju se najbolje. Od osvježavajućih kupanja i modernih frizura do skraćivanja noktiju i nježnog četkanja, nudimo širok spektar usluga šišanja prilagođenih potrebama vašeg ljubimca. Zakažite termin danas i dopustite nam da razmazimo vaše ljubimce do savršenstva!",
                        DateTime.UtcNow.AddDays(-14),2,false },
                    { 4, "Posebna ponuda",
                        "Kod nas u pet shopu, novi članovi obitelji su posebno važni! Stoga smo pripremili posebnu ponudu za sve koji su nedavno udomili psa ili mačku. Dobijte 15% popusta na sve potrepštine za vašeg ljubimca, uključujući hranu, igračke i ostalu opremu. Obradujte svog novog prijatelja kvalitetnim proizvodima po povoljnoj cijeni.",
                        DateTime.UtcNow.AddDays(-17),1,false },
                    { 5, "Novi dolazak",
                        "Pozdravite naše nove stanovnike akvarija - prekrasne tropske ribice! Uz bogate boje i fascinantne obrasce, ove ribice će oživjeti vaš akvarij i stvoriti pravu morsku atmosferu. Posjetite nas i pronađite idealne suputnike za vaš akvarij. Naše stručno osoblje će vam pružiti savjete o njezi i održavanju kako bi vaši novi stanovnici bili sretni i zdravi.",
                        DateTime.UtcNow.AddDays(-20),3,false },
                    { 6, "Zdrava prehrana za vaše ljubimce",
                        "Želite li pružiti najbolje svojim ljubimcima? Sada možete! U našem pet shopu uvodimo širok asortiman organske hrane za pse i mačke. Bez umjetnih sastojaka i puna nutritivnih vrijednosti, ova zdrava prehrana će podržati vitalnost i dobro zdravlje vašeg ljubimca. Posjetite nas i informirajte se o našem organskom asortimanu hrane i poslastica.",
                        DateTime.UtcNow.AddDays(-12),2,false },
                });

            migrationBuilder.InsertData(
               table: "Narudzbe",
               columns: new[] { "NarudzbaId", "DatumNarudzbe", "TotalFinal", "StateMachine", "KupacId", "PaymentId", "PaymentIntent" },
               values: new object[,]
               {
                    {1, DateTime.UtcNow.AddDays(-12),200m,"Done",1,"FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ","FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    {2, DateTime.UtcNow.AddDays(-17),10m,"Done",1,"FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ","FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    {3, DateTime.UtcNow.AddDays(-19), 250m, "Done", 1, "FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ", "FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    {4, DateTime.UtcNow.AddDays(-20), 300m, "Done", 2,"FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ","FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    {5, DateTime.UtcNow.AddDays(-7), 25m, "Done", 2, "FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ", "FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    {6, DateTime.UtcNow.AddDays(-4), 10m, "Done", 3, "FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ", "FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    {7, DateTime.UtcNow.AddDays(-1).AddMonths(-1),510m,"Draft",3,"FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ","FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    {8, DateTime.UtcNow.AddDays(-28).AddMonths(-1),560m,"Done",3,"FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ","FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    {9, DateTime.UtcNow.AddDays(-25).AddMonths(-1), 510m, "Done", 3,"FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ","FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    {10, DateTime.UtcNow.AddDays(-21).AddMonths(-1), 510m, "Draft", 3,"FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ","FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    { 11, DateTime.UtcNow.AddDays(-5).AddMonths(-1), 560m, "Done", 3,"FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ","FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    { 12, DateTime.UtcNow.AddDays(-9).AddMonths(-1), 510m, "Done", 3,"FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ","FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    { 13, DateTime.UtcNow.AddDays(-18).AddMonths(-1), 210m, "Draft", 3,"FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ","FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    { 14, DateTime.UtcNow.AddDays(-12).AddMonths(-1), 210m, "Done", 3,"FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ","FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
                    { 15, DateTime.UtcNow.AddDays(-10).AddMonths(-1), 210m, "Draft", 3,"FAKE_SEED_cs_test_b11Gj9AcTD5FrTzoZFwu6MBy4USeka8s5dGY6K3KDXUKqOdWU0qkEFDovQ","FAKE_SEED_pi_3NfHcmFfEoaxkl080gC8RK19"},
               });

            migrationBuilder.InsertData(
               table: "NarudzbeArtikli",
               columns: new[] { "NarudzbaArtikalId", "NarudzbaId", "ArtikalId" },
               values: new object[,]
               {
                    { 1, 1, 1 },
                    { 2, 2, 17 },
                    { 3, 3, 11 },
                    { 4, 4, 10 },
                    { 5, 5, 16 },
                    { 6, 6, 21 },

                    { 7, 7, 3 },
                    { 8, 7, 10 },
                    { 9, 7, 17 },

                    { 10, 8, 2 },
                    { 11, 8, 10 },
                    { 12, 8, 17 },

                    { 13, 9, 3 },
                    { 14, 9, 10 },
                    { 15, 9, 17 },

                    { 16, 10, 6 },
                    { 17, 10, 12 },
                    { 18, 10, 19 },

                    { 19, 11, 5 },
                    { 20, 11, 12 },
                    { 21, 11, 19 },

                    { 22, 12, 6 },
                    { 23, 12, 12 },
                    { 24, 12, 19 },

                    { 25, 13, 14 },
                    { 26, 13, 8 },
                    { 27, 13, 21 },

                    { 28, 14, 14 },
                    { 29, 14, 8  },
                    { 30, 14, 21 },

                    { 31, 15, 14 },
                    { 32, 15, 8  },
                    { 33, 15, 21 },

               });

            migrationBuilder.InsertData(
                table: "Zivotinje",
                columns: new[] { "ZivotinjaId", "Naziv", "Napomena", "Cijena", "Dostupnost", "DatumPostavljanja", "StateMachine", "NarudzbaId", "VrstaId" },
                values: new object[,]
                {
                    { 1, "Crni","",1300m,true,DateTime.UtcNow.AddDays(-10),"Active",null,1 },
                    { 2, "Dzeki","",1200m,true,DateTime.UtcNow.AddDays(-15),"Active",null,2 },
                    { 3, "Pujdo","",1001m,true,DateTime.UtcNow.AddDays(-2),"Active",null,3 },
                    { 4, "Bela","",1000m,true,DateTime.UtcNow.AddDays(-7),"Active",null,4 },
                    { 5, "Zlata","",1199m,true,DateTime.UtcNow.AddDays(-12),"Active",null,5 },
                    { 6, "Ramzes","",1315m,true,DateTime.UtcNow.AddDays(-9),"Active",null,6 },
                    { 7, "Dzek","",550m,true,DateTime.UtcNow.AddDays(-2),"Active",null,7 },
                    { 8, "Halid","",460m,true,DateTime.UtcNow.AddDays(-5),"Active",null,8 },
                    { 9, "Bobi","",250m,true,DateTime.UtcNow.AddDays(-14),"Active",null,9 },

                    { 10, "Crni2","",100m,true,DateTime.UtcNow.AddDays(-12).AddMonths(-1),"Reserved",7,1 },
                    { 11, "Dzeki2","",100m,true,DateTime.UtcNow.AddDays(-11).AddMonths(-1),"Sold",8,2 },
                    { 12, "Pujdo2","",100m,true,DateTime.UtcNow.AddDays(-5).AddMonths(-1),"Sold",9,3 },
                    { 13, "Bela2","",100m,true,DateTime.UtcNow.AddDays(-13).AddMonths(-1),"Reserved",10,4 },
                    { 14, "Zlata2","",100m,true,DateTime.UtcNow.AddDays(-1).AddMonths(-1),"Sold",11,5 },
                    { 15, "Ramzes2","",100m,true,DateTime.UtcNow.AddDays(-9).AddMonths(-1),"Sold",12,6 },
                    { 16, "Dzek2","",100m,true,DateTime.UtcNow.AddDays(-17).AddMonths(-1),"Reserved",13,7 },
                    { 17, "Halid2","",100m,true,DateTime.UtcNow.AddDays(-25).AddMonths(-1),"Sold",14,8 },
                    { 18, "Bobi2","",100m,true,DateTime.UtcNow.AddDays(-21).AddMonths(-1),"Reserved",15,9 },
                });

            migrationBuilder.InsertData(
               table: "Slike",
               columns: new[] { "SlikaId", "Naziv", "Putanja", "ArtikalId", "ZivotinjaId", "isDeleted" },
               values: new object[,]
               {
                    { 1, "HranaPsi1","http://localhost:7152/SlikeArtikala/HranaPsi1.jpg",1,null,false },
                    { 2, "HranaPsi2","http://localhost:7152/SlikeArtikala/HranaPsi2.jpg",2,null,false },
                    { 3, "HranaPsi3","http://localhost:7152/SlikeArtikala/HranaPsi3.jpg",3,null,false },
                    { 4, "HranaMacke1","http://localhost:7152/SlikeArtikala/HranaMacke1.jpg",4,null,false },
                    { 5, "HranaMacke2","http://localhost:7152/SlikeArtikala/HranaMacke2.jpg",5,null,false },
                    { 6, "HranaMacke3","http://localhost:7152/SlikeArtikala/HranaMacke3.jpg",6,null,false },
                    { 7, "HranaPtice1","http://localhost:7152/SlikeArtikala/HranaPtice1.jpg",7,null,false },
                    { 8, "HranaPtice2","http://localhost:7152/SlikeArtikala/HranaPtice2.jpg",8,null,false },
                    { 9, "HranaPtice3","http://localhost:7152/SlikeArtikala/HranaPtice3.jpg",9,null,false },
                    { 10, "KucicaPsi1","http://localhost:7152/SlikeArtikala/KucicaPsi1.jpg",10,null,false },
                    { 11, "KucicaPsi2","http://localhost:7152/SlikeArtikala/KucicaPsi2.jpg",11,null,false },
                    { 12, "KucicaMacke1","http://localhost:7152/SlikeArtikala/KucicaMacke1.jpg",12,null,false },
                    { 13, "KucicaMacke2","http://localhost:7152/SlikeArtikala/KucicaMacke2.jpg",13,null,false },
                    { 14, "KucicaPtice1","http://localhost:7152/SlikeArtikala/KucicaPtice1.jpg",14,null,false },
                    { 15, "KucicaPtice2","http://localhost:7152/SlikeArtikala/KucicaPtice2.jpg",15,null,false },
                    { 16, "IgrackaPsi1","http://localhost:7152/SlikeArtikala/IgrackaPsi1.jpg",16,null,false },
                    { 17, "IgrackaPsi2","http://localhost:7152/SlikeArtikala/IgrackaPsi2.jpg",17,null,false },
                    { 18, "IgrackaMacke1","http://localhost:7152/SlikeArtikala/IgrackaMacke1.jpg",18,null,false },
                    { 19, "IgrackaMacke2","http://localhost:7152/SlikeArtikala/IgrackaMacke2.jpg",19,null,false },
                    { 20, "IgrackaPtice1","http://localhost:7152/SlikeArtikala/IgrackaPtice1.jpg",20,null,false },
                    { 21, "IgrackaPtice2","http://localhost:7152/SlikeArtikala/IgrackaPtice2.jpg",21,null,false },
                    { 22, "Sarplaninac1","http://localhost:7152/SlikeZivotinja/Sarplaninac1.jpg",null,1,false },
                    { 23, "Sarplaninac2","http://localhost:7152/SlikeZivotinja/Sarplaninac2.jpg",null,1,false },
                    { 24, "Labrador1","http://localhost:7152/SlikeZivotinja/Labrador1.jpg",null,2,false },
                    { 25, "Labrador2","http://localhost:7152/SlikeZivotinja/Labrador2.jpg",null,2,false },
                    { 26, "Dalmatinac1","http://localhost:7152/SlikeZivotinja/Dalmatinac1.jpg",null,3,false },
                    { 27, "Dalmatinac2","http://localhost:7152/SlikeZivotinja/Dalmatinac2.jpg",null,3,false },
                    { 28, "Perzijska1","http://localhost:7152/SlikeZivotinja/Perzijska1.jpg",null,4,false },
                    { 29, "Perzijska2","http://localhost:7152/SlikeZivotinja/Perzijska2.jpg",null,4,false },
                    { 30, "Abesinska1","http://localhost:7152/SlikeZivotinja/Abesinska1.jpg",null,5,false },
                    { 31, "Abesinska2","http://localhost:7152/SlikeZivotinja/Abesinska2.jpg",null,5,false },
                    { 32, "Egipatska1","http://localhost:7152/SlikeZivotinja/Egipatska1.jpg",null,6,false },
                    { 33, "Egipatska2","http://localhost:7152/SlikeZivotinja/Egipatska2.jpg",null,6,false },
                    { 34, "Papagaj1","http://localhost:7152/SlikeZivotinja/Papagaj1.jpg",null,7,false },
                    { 35, "Papagaj2","http://localhost:7152/SlikeZivotinja/Papagaj2.jpg",null,7,false },
                    { 36, "Kanarinac1","http://localhost:7152/SlikeZivotinja/Kanarinac1.jpg",null,8,false },
                    { 37, "Kanarinac2","http://localhost:7152/SlikeZivotinja/Kanarinac2.jpg",null,8,false },
                    { 38, "Golub1","http://localhost:7152/SlikeZivotinja/Golub1.jpg",null,9,false },
                    { 39, "Golub2","http://localhost:7152/SlikeZivotinja/Golub2.jpg",null,9,false },
                    { 40, "Sarplaninac1","http://localhost:7152/SlikeZivotinja/Sarplaninac1.jpg",null,10,false },
                    { 41, "Sarplaninac2","http://localhost:7152/SlikeZivotinja/Sarplaninac2.jpg",null,10,false },
                    { 42, "Labrador1","http://localhost:7152/SlikeZivotinja/Labrador1.jpg",null,11,false },
                    { 43, "Labrador2","http://localhost:7152/SlikeZivotinja/Labrador2.jpg",null,11,false },
                    { 44, "Dalmatinac1","http://localhost:7152/SlikeZivotinja/Dalmatinac1.jpg",null,12,false },
                    { 45, "Dalmatinac2","http://localhost:7152/SlikeZivotinja/Dalmatinac2.jpg",null,12,false },
                    { 46, "Perzijska1","http://localhost:7152/SlikeZivotinja/Perzijska1.jpg",null,13,false },
                    { 47, "Perzijska2","http://localhost:7152/SlikeZivotinja/Perzijska2.jpg",null,13,false },
                    { 48, "Abesinska1","http://localhost:7152/SlikeZivotinja/Abesinska1.jpg",null,14,false },
                    { 49, "Abesinska2","http://localhost:7152/SlikeZivotinja/Abesinska2.jpg",null,14,false },
                    { 50, "Egipatska1","http://localhost:7152/SlikeZivotinja/Egipatska1.jpg",null,15,false },
                    { 51, "Egipatska2","http://localhost:7152/SlikeZivotinja/Egipatska2.jpg",null,15,false },
                    { 52, "Papagaj1","http://localhost:7152/SlikeZivotinja/Papagaj1.jpg",null,16,false },
                    { 53, "Papagaj2","http://localhost:7152/SlikeZivotinja/Papagaj2.jpg",null,16,false },
                    { 54, "Kanarinac1","http://localhost:7152/SlikeZivotinja/Kanarinac1.jpg",null,17,false },
                    { 55, "Kanarinac2","http://localhost:7152/SlikeZivotinja/Kanarinac2.jpg",null,17,false },
                    { 56, "Golub1","http://localhost:7152/SlikeZivotinja/Golub1.jpg",null,18,false },
                    { 57, "Golub2","http://localhost:7152/SlikeZivotinja/Golub2.jpg",null,18,false },
               });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}

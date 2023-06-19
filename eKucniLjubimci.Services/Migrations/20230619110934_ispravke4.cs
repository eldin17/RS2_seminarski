using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eKucniLjubimci.Services.Migrations
{
    /// <inheritdoc />
    public partial class ispravke4 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Kolicina",
                table: "Artikli");

            migrationBuilder.DropColumn(
                name: "Total",
                table: "Artikli");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Kolicina",
                table: "Artikli",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "Total",
                table: "Artikli",
                type: "decimal(18,2)",
                nullable: true);
        }
    }
}

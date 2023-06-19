using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eKucniLjubimci.Services.Migrations
{
    /// <inheritdoc />
    public partial class treca : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "isDeleted",
                table: "Vrste",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "isDeleted",
                table: "Slike",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "isDeleted",
                table: "Lokacije",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "isDeleted",
                table: "Kategorije",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "isDeleted",
                table: "Vrste");

            migrationBuilder.DropColumn(
                name: "isDeleted",
                table: "Slike");

            migrationBuilder.DropColumn(
                name: "isDeleted",
                table: "Lokacije");

            migrationBuilder.DropColumn(
                name: "isDeleted",
                table: "Kategorije");
        }
    }
}

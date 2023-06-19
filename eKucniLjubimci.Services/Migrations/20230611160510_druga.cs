using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eKucniLjubimci.Services.Migrations
{
    /// <inheritdoc />
    public partial class druga : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "StateMachine",
                table: "Osobe");

            migrationBuilder.AddColumn<bool>(
                name: "isDeleted",
                table: "Osobe",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "isDeleted",
                table: "Osobe");

            migrationBuilder.AddColumn<string>(
                name: "StateMachine",
                table: "Osobe",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }
    }
}

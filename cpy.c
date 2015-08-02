//*********************************************
//		Instituto Tecnológico de Costa Rica
//		Ingeniería en Computadores
//		Principios de Sistemas Operativos
//		II Semestre 2015
//		
//		Author: Yeison Arturo Cruz León
//		Carné: 201258348
//*********************************************

#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <assert.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[])
{
	int i, _fileSize, _sectorCount = 4, _fileTable, _sectorNumber = 5;

	char _generalBuffer[1024];
	char _fileBuffer;
	int _deviceUSB, _openFile, _offset = 0;

	_openFile = open(argv[2], O_RDONLY);
	assert(_openFile > 0);
	read(_openFile, _generalBuffer, 512);
	close(_openFile);

	printf("El gestor de arranque \'%s\' ha sido cargado correctamente.\n", argv[2]);
	

	_deviceUSB = open(argv[1], O_RDWR);
	assert(_deviceUSB > 0);
	write(_deviceUSB, _generalBuffer, 512);


	_fileTable = open("filetable", O_CREAT | O_RDWR);
	sprintf(_generalBuffer, "{");
	write(_fileTable, _generalBuffer, 1);

	_openFile = open(argv[3], O_RDWR);
	assert(_deviceUSB > 0);
	lseek(_openFile, 0, SEEK_SET);
	read(_openFile, _generalBuffer, 1024);
	lseek(_deviceUSB, 1024, SEEK_SET);
	write(_deviceUSB, _generalBuffer, 1024);	

	printf("El Sistema Operativo Yeison O.S ha sido cargado correctamente.\n");
	
	for(i = 4; i < argc; i++)
	{	
		_offset = _offset + (_sectorCount * 512);
		lseek(_deviceUSB, _offset, SEEK_SET);
		_openFile = open(argv[i], O_RDONLY);
		assert(_openFile > 0);
		_fileSize = 0;		
		while((read(_openFile, &_fileBuffer, 1)) != 0) 
		{
			_fileSize++;
			write(_deviceUSB, &_fileBuffer, 1);
		}
		_sectorCount = (_fileSize > 512) ? 2:1;

		sprintf(_generalBuffer, "%s-%d,", argv[i], _sectorNumber);
		write(_fileTable, _generalBuffer, strlen(_generalBuffer));
		printf("Archivo \'%s\' escrito en el offset %d del dispositivo USB.\n", argv[i], _offset);
		close(_openFile);
	
		_sectorNumber = _sectorNumber + _sectorCount;
	}
	sprintf(_generalBuffer, "}");
	write(_fileTable, _generalBuffer, 1);

	lseek(_fileTable, 0, SEEK_SET);
	read(_fileTable, _generalBuffer, 512);

	lseek(_deviceUSB, 512, SEEK_SET);
	write(_deviceUSB, _generalBuffer, 512);	
	close (_deviceUSB);
	close(_fileTable);
}

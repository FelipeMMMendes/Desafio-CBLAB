import os
from pathlib import Path
from uuid import uuid4


class FilesUtils:
    """Uma classe utilitária para operações relacionadas a arquivos e diretórios."""

    @classmethod
    def create_tmp_dir(cls):
        """
        Cria um diretório temporário com um nome único baseado em UUID.

        Returns:
            str: O caminho absoluto para o diretório temporário criado.
        """
        pasta_do_processo = Path(f"/dados/{uuid4()!s}/")
        pasta_do_processo.mkdir(parents=True)
        return pasta_do_processo.absolute().as_posix()

    @classmethod
    def scan_tree_for_files(cls, diretorio: str, extension=None):
        """
        Gera caminhos para todos os arquivos em um diretório e subdiretórios.

        Args:
            diretorio (str): O diretório a ser escaneado.
            extension (str, optional): A extensão dos arquivos a serem filtrados (opcional).

        Yields:
            str: O caminho absoluto para cada arquivo encontrado.
        """
        for file in os.scandir(diretorio):
            if file.is_file(follow_symlinks=False):
                if extension and file.name.endswith(extension) or extension is None:
                    yield file.path
            elif file.is_dir(follow_symlinks=False):
                yield from cls.scan_tree_for_files(file)

    @classmethod
    def scan_tree_for_dirs(cls, diretorio: str):
        """
        Gera caminhos para todos os diretórios em um diretório e subdiretórios.

        Args:
            diretorio (str): O diretório a ser escaneado.

        Yields:
            str: O caminho absoluto para cada diretório encontrado.
        """
        for file in os.scandir(diretorio):
            if file.is_dir(follow_symlinks=False):
                yield file.path

    @classmethod
    def clean_files_in_a_dir(cls, diretorio_para_limpar: str):
        """
        Remove todos os arquivos e diretórios de um diretório especificado e seus subdiretórios.

        Args:
            diretorio_para_limpar (str): O diretório a ser limpo.

        Raises:
            AssertionError: Se o diretório não estiver localizado em "/dados".

        """
        assert diretorio_para_limpar.startswith("/dados")

        for diretorio in cls.scan_tree_for_dirs(diretorio_para_limpar):
            cls.clean_files_in_a_dir(diretorio)
            if Path(diretorio).exists():
                os.removedirs(diretorio)
                print(f"REMOVED DIR: {diretorio}")

        for file in cls.scan_tree_for_files(diretorio_para_limpar):
            os.unlink(file)
            print(f"REMOVED FILE: {file}")

        dir_para_limpar = Path(diretorio_para_limpar)

        if dir_para_limpar.exists():
            dir_para_limpar.rmdir()
            print(f"REMOVED DIR: {dir_para_limpar.absolute().as_posix()}")

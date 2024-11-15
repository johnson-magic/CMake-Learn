#!/bin/sh

# Display usage
cpack_usage()
{
  cat <<EOF
Usage: $0 [options]
Options: [defaults in brackets after descriptions]
  --help            print this message
  --version         print cmake installer version
  --prefix=dir      directory in which to install
  --include-subdir  include the Tutorial-1.0-Linux subdirectory
  --exclude-subdir  exclude the Tutorial-1.0-Linux subdirectory
  --skip-license    accept license
EOF
  exit 1
}

cpack_echo_exit()
{
  echo $1
  exit 1
}

# Display version
cpack_version()
{
  echo "Tutorial Installer Version: 1.0, Copyright (c) Humanity"
}

# Helper function to fix windows paths.
cpack_fix_slashes ()
{
  echo "$1" | sed 's/\\/\//g'
}

interactive=TRUE
cpack_skip_license=FALSE
cpack_include_subdir=""
for a in "$@"; do
  if echo $a | grep "^--prefix=" > /dev/null 2> /dev/null; then
    cpack_prefix_dir=`echo $a | sed "s/^--prefix=//"`
    cpack_prefix_dir=`cpack_fix_slashes "${cpack_prefix_dir}"`
  fi
  if echo $a | grep "^--help" > /dev/null 2> /dev/null; then
    cpack_usage
  fi
  if echo $a | grep "^--version" > /dev/null 2> /dev/null; then
    cpack_version
    exit 2
  fi
  if echo $a | grep "^--include-subdir" > /dev/null 2> /dev/null; then
    cpack_include_subdir=TRUE
  fi
  if echo $a | grep "^--exclude-subdir" > /dev/null 2> /dev/null; then
    cpack_include_subdir=FALSE
  fi
  if echo $a | grep "^--skip-license" > /dev/null 2> /dev/null; then
    cpack_skip_license=TRUE
  fi
done

if [ "x${cpack_include_subdir}x" != "xx" -o "x${cpack_skip_license}x" = "xTRUEx" ]
then
  interactive=FALSE
fi

cpack_version
echo "This is a self-extracting archive."
toplevel="`pwd`"
if [ "x${cpack_prefix_dir}x" != "xx" ]
then
  toplevel="${cpack_prefix_dir}"
fi

echo "The archive will be extracted to: ${toplevel}"

if [ "x${interactive}x" = "xTRUEx" ]
then
  echo ""
  echo "If you want to stop extracting, please press <ctrl-C>."

  if [ "x${cpack_skip_license}x" != "xTRUEx" ]
  then
    more << '____cpack__here_doc____'
this is a license.txt.

____cpack__here_doc____
    echo
    while true
      do
        echo "Do you accept the license? [yn]: "
        read line leftover
        case ${line} in
          y* | Y*)
            cpack_license_accepted=TRUE
            break;;
          n* | N* | q* | Q* | e* | E*)
            echo "License not accepted. Exiting ..."
            exit 1;;
        esac
      done
  fi

  if [ "x${cpack_include_subdir}x" = "xx" ]
  then
    echo "By default the Tutorial will be installed in:"
    echo "  \"${toplevel}/Tutorial-1.0-Linux\""
    echo "Do you want to include the subdirectory Tutorial-1.0-Linux?"
    echo "Saying no will install in: \"${toplevel}\" [Yn]: "
    read line leftover
    cpack_include_subdir=TRUE
    case ${line} in
      n* | N*)
        cpack_include_subdir=FALSE
    esac
  fi
fi

if [ "x${cpack_include_subdir}x" = "xTRUEx" ]
then
  toplevel="${toplevel}/Tutorial-1.0-Linux"
  mkdir -p "${toplevel}"
fi
echo
echo "Using target directory: ${toplevel}"
echo "Extracting, please wait..."
echo ""

# take the archive portion of this file and pipe it to tar
# the NUMERIC parameter in this command should be one more
# than the number of lines in this header file
# there are tails which don't understand the "-n" argument, e.g. on SunOS
# OTOH there are tails which complain when not using the "-n" argument (e.g. GNU)
# so at first try to tail some file to see if tail fails if used with "-n"
# if so, don't use "-n"
use_new_tail_syntax="-n"
tail $use_new_tail_syntax +1 "$0" > /dev/null 2> /dev/null || use_new_tail_syntax=""

extractor="pax -r"
command -v pax > /dev/null 2> /dev/null || extractor="tar xf -"

tail $use_new_tail_syntax +151 "$0" | gunzip | (cd "${toplevel}" && ${extractor}) || cpack_echo_exit "Problem unpacking the Tutorial-1.0-Linux"

echo "Unpacking finished successfully"

exit 0
#-----------------------------------------------------------
#      Start of TAR.GZ file
#-----------------------------------------------------------;
� ��"g �\t[ŕI��8����I�A��!�"�?�9�����m��,=�Z,�HO������6u��t�l	%�)g9-�mPZ����n�䴀wٶ�lM�����!�;�f���KBH��V���w���Ν����͝h<<��(��yL>�������X�㩞<��F�����������|5��S>�b)�R�$���S�锒��;]>��N���(������I�;p>ʀ�h�����������������k|��;Έ�ϼ�/J��1ٓ���R��4.ǔԐV<1Y�K��j4Oy>��DU�I�{A���*�/�T��-��%6���j"�[�h����v�������Z���~|�/���.�(}Ѹ�a�/�\��v�Z������y���mkA���t���:��C��J���h���������j��5����#��gS�|����޲��|~�����^���#}>ؾ�n��]�0�����Zs:Ԅ���_�ɉt�n�.�M�ҡ�"�2RG�NQw��"wN���"}i���z�<�j+2R^���R�����n���+�٩^e��W�0R��HY{ѿ&jW�����z*'R����<N]����)����"�2RV�g@��ybݻ��g�.���q�l0��P�l0R=�������꼩��F������=���1����Gy�︢s���?�2���/�ߕ��d��lب��v���"�O�"���Cʋ���g�X��00��l��&d�����v�rwZ�߰����Z�s����Y��XȿlQ�
\��1��>�jQ�:�OYȻ-��X��)�y�~ʽ��|6Z���l���I���%x�4 I�%�~Ȫ�����)�$��hJU��-����-�*Z�y�g�v%S��~%Wr[8��n�K�S���p����䤤&娚	����k{�T4,%RjR�cm�R�O
v5HD��N�ԁd�)�$F#���Oǔ�ڹ&LJR%)<<���k4C`'�7+�xl�Awݚ�ZI3�M�$�U���Q�z�U�sպ�D�č5<,)�T"n���M>��-Te͇w����vL��Y�����%�	�5`�|xor=N�U�|� �}RR��+�dN�a��G�I=�;��NIA���0f0�·I�ۤ>9:��	5�\�%YU��P��$��4��xU��¯Wh�;a�I� �19G�[Z�Z���_߼�M�{k������\�_{k�+հ�����0v���?\��U<74��<)J�|�מ�X��:����y��X�E�p�����<��mN��x�ꨋ��¶~M�ۧ���ۺ�����h�?�NP,� :{^Lh���{�ҋF|d>���>��~��t\#���k5��}왇�Awp�!��&8|6���y>���9|��/��i��p7��
g�M������N	ʽ���p�������������^�����!����ί�l�����gq���q�n/������9������8�_�
���<�*�y�����ep��6�ڳ�B#ϸ��l})�G�W�Rq1�'����l6;Fx�뼝��u�A���|��y'�w�|1ῠ�%��]�]��u~�?��o�������,�_��e����儷�|����ۼ�5Z���X��[�_�_�K�S�V� ���o	�C������
�6�������2�oe�#4�S�����>��h��1Y����IPywX�����-�V���[[���#o��� � g�����'C����w��v�lυ�T灁+�W�H��c���x�D�%=��?�����ЎŠ6��u2���s��n]��w@&���.�-�-{B��X$���*b/8�ٲ�V��	����v ��.�r(*q�,,���|`hC3��m�y�?�<D�n�y�A,E�`���|@n�E��	Ș|�*�r�ir��^&�|q�n�> Ǟ��
i��cXԉ�ŶF����
��<Y�̋8�^b78�{����*���>M���ٚ�����B���w�9�����g��L�W��`ф��_���W3��&t��u��^��W�u{'>�蘌�jg��R�~����2��} �fI$>�"�L����K�yf`�-�`����l9�IO�l9aK�|a�t6#m1Ԧw�(��������.���z�V�c/��~�U��]1����Pf�4�)��4������B��`����>�X�3/�Y�� �nl$� �<�˃cy��`Y�m<]6y.mG��97��ъ��i��9g�� ����}�L�áL�^a�@�3v�,n��C����E��2���llL@ơ�����Yx<`�G߃���{س��K�9�Oh���}q\-!��M'qx]�((�p'��GB#[�"�~(�J'M�7�q�H���ͼ|����$�(�j�^��܀!�O���w���30>\����T_����*�'�3��-�?�u�9������sf]�Nlj�ϸȬy��|�8���>�Ǐ�5^:���{V��:��"eى����Ȗ�fT�|�24���e��1�Al��:x�⦃�����(�͆�s�F�o�V����'2S�S��<��L{�|�q2��.m�3��r]�N���\U_���[�7�Z��^8�I�;29M&��+�$���L�W��\�0}�I�筸��d�����GW�wB�7�e^n�i�k�nΜ�	�V���}���k������P/��J�7홣�wZ3�i���Uh�-��������4��|K��ҁ�\����{���VH�TH�TH�d��:0J�r�J2M�=ȋzRr�r�y��X��D��'u{ZN*�d"�z}�MyrvzR�G)��	π28���#9�ƣjT�l��
�jIĆ�j4���{G���͞p<�yXL��G`�W�
�W_/|�oqz��G��-t|
3�k����:0��N�G����}��G�ٍ����f�w����9P��f�]	�a�1��~�$�్���«�Ѝ��v���N����lM�v�:dv��*q��4�m������y9�����w�7��Q�^U^y]��;\[ѵ�����K�ݛ�o�ʯ�b\�u�_@�e}��C6��r�=��������Y���N<-���_ ���{9��8�[u+z���q8�6b�y��r���������z��:ȿ����k�|�ã���\Q���;��]�u�uo�ު���ȿ������䯆1�ڸ|�m� ����w���	�?x��>�O�	h�C����U�����ʯ8��Ѣ`y՗���{�C�M#%�����r_sy��r���ʕ���.��c����٬��k�G�v�k���|с~b���d�^��]���TH�TH�TH�TH��ۿ�����)l?
�ߘ��v#����������]�w���YHy�W��a�c��8ۋq�d6��^�م��u�M.l��A���d̡<ۋ���������T�_Tl��VZQ�;��a{_�f�R��T��a�/BF���Z�l:I��T1Ky���{i�qʟ�7Z��ZL>��J;)�H��[)�t/��(���G(�b?��%7�~�9Hl�թ�Ե���������O��Xŝ�{�����Y��f�r�l��nG����*g�ځ���RV��\����M�մg������	翻����ykk���;�*f�]ߏn���v#^��2ŝ��3���|3�%��4�.}���87��|2�3�yg�g7E�x����g2��Lq�b�g��9#>�t�������yh�%f�|4q�~�~?5���Q#^i:�pwf�=#� �b�s����'�0-~��Y��;��О��+��P���7�2���\y8�"����v<s��f"�ߞ�-����AEc��ԟ]�?�B�m���g)Ξ�l͵��܀E�_�(��Jc�x��U��٪�m8o���84�����b\n�<]O��O�ع ���k��?�������� �x�O���?n�� nTJ7M.��\���l/�vM����i�x�g,�ʉ�n����2��r��Nܗg��=�����ۀ_v�>^���,��{�}��v~i��tj�b�U�;m!����`��-�]EZ���~�y\�?Y�q:��#��W��f#>ǩ��z:~�{�6���}N͎��S��:�V��bs;Wk��I�K�x���x��<~&c!���}��8������X�Wm�E��KK4�~��R���|~m-1/��s��m!���|��������U�����en��jJM��y�($�1)��RH�"	�0�+J5�LIrz���AEU"�&_��\vD%9��7KJ\MnF}I9�H�t,�T8N���*������I�J��PT	+wDS�N�Sj2֢Wڛ$)��&���X5��W��$�D��)�hz��E�HZ�~���vPI�JmZ�	=��l��8���V�k�J���8�JZ��G
�(j]��֛�6w��@��n#@b]�b�_��+�-u7�lJy�2� �")Y��]�\���iԀ랐�"��u�`��'u��:�t���ήZ�u��FQ8�(ֵ����.y������]V"Ѹ�N)�s\�9���퐋�1�	�t֑i�b�O%�C$�41k���Fi�մ�FoR��ƩiWB����v9�H����t��,BPlLc�X�5������R;��� <��d����'���s�zR&�����Jn���%�ն��^_0x�<��zS)�S���&��5k��3m�`g�*�P,��SiI�˚��@����D;��>5�����/-��O,����k�n5hm5h��9���[��(N`c�.�5iW���s�x�a1��ѴF��7�9�ʽ@�D� ��� 9���x�3�P2cI��A���`�:���jU�G$o@N ods�Ш��r6i;h�yIePƂ�jhP�^�@Ɨ���H)a�{%�d@y�	��*�ee ��qPL8,)�aeH�Ⱦͪ�h�l�k(\�E��f�0��m6�0{)��	�g�WR�nlu�K6��?���F��$Xr	|��/�cq� /�!�&�u��,��o��?f�	�����8[����F��ٺ"��i�e�l=�������#�S��;��ؙ>[�d�A��.л��f�x�������@��EZ�2}���(�� ����T��d료n��/2��gl���a������#��VF�B���������e�oE�}�>[���qOS���#�������E-���{��2yq��Tз:Wƪ�W}����(/�����֫],ȋ�￑��˦�~N=��R�w	�a��˙>[/tW��+�W،����CT���x=6�u�#V���Ӕ_i3���I��ϰ���E��!�g�Wþ�}>�,���/~nb�K����0DHz��O�� ��ل��?38����j��(t�8~f[�Bo�KQ���<����<��W8���H���~w�b�;��-�4��6B��?64�j
�?~�O����5��<��˻���&�����G�	p7�D}��n�ۛXv�R�����iy+U<��FO�S�S"@�wû�ن�b��\�ѐ\̅Fɫ�$�&q���Sŗ�!�4�Cr5�3�Մ�BrM}�Br�|M��"SF���MHnΑ��|�̸�©Br����۹�ҟ:�I��[�Nwr�U�^�a�8V1l3�UD��4�,"�*Y��@�3��p�wam��9��op);���>I���p�Bb�}�e;M�(�����2�&��a����d�i;�ĔF��B�}ؗ��#��6מ��L7��(,3�G�{x��_e�wZ�x��m�,m!?j���~\~?�c�;;����Y���N���4�izv�������Zj�w5��6^�g�-�l�n�p���DVK)���r�_R�*��#����s�N�~��@����~�]6#^G�
���g3����/��e�}v?h�����N�ͼ}6r�|����-���9�9���|%�?ba�9.��'9�8�V[_�a�k�/��% ��~�Q���S}�"���/?������_vؗ��<ī��l�OZDY�dt�	+�B{��iV��J:b<K�tiq=m�2d���J$�2���z��ȸR�[��y?2_�c��\|_��+�zb'�[�3���_'}5`�ۯ��u�|�����T�ŕ�.d�zXg�ʕ'F����t�_�>��۟}�W�E}|¹Y���Q��L��~V+���/u��+L��Vz��	�������}��m^X�-�B*$��?HGF t  
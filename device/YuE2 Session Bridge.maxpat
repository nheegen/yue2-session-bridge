{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 9,
      "minor": 0,
      "revision": 0,
      "architecture": "x64",
      "modernui": 1
    },
    "classnamespace": "box",
    "rect": [
      0,
      0,
      1520,
      850
    ],
    "openrect": [
      0,
      0,
      1520,
      169
    ],
    "openinpresentation": 1,
    "devicewidth": 1520,
    "default_fontname": "Arial",
    "default_fontsize": 11,
    "bgcolor": [
      0.075,
      0.09,
      0.11,
      1
    ],
    "boxes": [
      {
        "box": {
          "id": "title",
          "maxclass": "comment",
          "patching_rect": [
            10,
            3,
            175,
            18
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            3,
            175,
            18
          ],
          "text": "YuE2 SESSION / 0.5.1",
          "fontsize": 11,
          "textcolor": [
            0.78,
            0.81,
            0.84,
            1
          ],
          "annotation_name": "YuE2 Session Bridge",
          "annotation": "Use Session MIDI harmony and bass to guide YuE2 in ComfyUI. Choose source clips, build and review ABC, then generate a take."
        }
      },
      {
        "box": {
          "id": "refresh",
          "maxclass": "textbutton",
          "patching_rect": [
            192,
            0,
            73,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            192,
            0,
            73,
            22
          ],
          "text": "Refresh",
          "texton": "Refresh",
          "mode": 1,
          "fontsize": 11,
          "bgcolor": [
            0.24,
            0.31,
            0.36,
            1
          ],
          "textcolor": [
            1,
            1,
            1,
            1
          ],
          "annotation_name": "Refresh sources and destinations",
          "annotation": "Update the lists of Session MIDI clips and audio tracks after adding, moving, deleting or renaming them. Review existing source numbers after reordering tracks or scenes."
        }
      },
      {
        "box": {
          "id": "sel_refresh",
          "maxclass": "newobj",
          "patching_rect": [
            192,
            520,
            55,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "cmd_refresh",
          "maxclass": "message",
          "patching_rect": [
            192,
            550,
            73,
            22
          ],
          "text": "refresh"
        }
      },
      {
        "box": {
          "id": "trigger_refresh",
          "maxclass": "newobj",
          "patching_rect": [
            192,
            590,
            50,
            22
          ],
          "text": "t b b"
        }
      },
      {
        "box": {
          "id": "reset_refresh",
          "maxclass": "message",
          "patching_rect": [
            192,
            620,
            50,
            22
          ],
          "text": "set 0"
        }
      },
      {
        "box": {
          "id": "clipmenu",
          "maxclass": "umenu",
          "patching_rect": [
            10,
            25,
            255,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            25,
            255,
            22
          ],
          "varname": "clipmenu",
          "items": [
            "Press Refresh"
          ],
          "parameter_enable": 0,
          "annotation_name": "Source MIDI clip",
          "annotation": "Choose a Session MIDI clip by track and clip name, then press Add chord or Add bass. You can combine several clips without selecting them elsewhere in Live."
        }
      },
      {
        "box": {
          "id": "pickmessage",
          "maxclass": "newobj",
          "patching_rect": [
            10,
            700,
            95,
            22
          ],
          "text": "prepend pick"
        }
      },
      {
        "box": {
          "id": "addchord",
          "maxclass": "textbutton",
          "patching_rect": [
            10,
            50,
            124,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            50,
            124,
            22
          ],
          "text": "Add chord",
          "texton": "Add chord",
          "mode": 1,
          "fontsize": 11,
          "bgcolor": [
            0.24,
            0.31,
            0.36,
            1
          ],
          "textcolor": [
            1,
            1,
            1,
            1
          ],
          "annotation_name": "Add chord source",
          "annotation": "Add the clip chosen in the source dropdown to the chord sources. Notes from all chord sources are combined into harmony over the requested passage."
        }
      },
      {
        "box": {
          "id": "sel_addchord",
          "maxclass": "newobj",
          "patching_rect": [
            10,
            570,
            55,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "cmd_addchord",
          "maxclass": "message",
          "patching_rect": [
            10,
            600,
            124,
            22
          ],
          "text": "add chords"
        }
      },
      {
        "box": {
          "id": "trigger_addchord",
          "maxclass": "newobj",
          "patching_rect": [
            10,
            640,
            50,
            22
          ],
          "text": "t b b"
        }
      },
      {
        "box": {
          "id": "reset_addchord",
          "maxclass": "message",
          "patching_rect": [
            10,
            670,
            50,
            22
          ],
          "text": "set 0"
        }
      },
      {
        "box": {
          "id": "addbass",
          "maxclass": "textbutton",
          "patching_rect": [
            140,
            50,
            125,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            140,
            50,
            125,
            22
          ],
          "text": "Add bass",
          "texton": "Add bass",
          "mode": 1,
          "fontsize": 11,
          "bgcolor": [
            0.24,
            0.31,
            0.36,
            1
          ],
          "textcolor": [
            1,
            1,
            1,
            1
          ],
          "annotation_name": "Add bass source",
          "annotation": "Add the clip chosen in the source dropdown to the bass sources. The converter preserves bass pitches and timing; the lowest active note is used when bass notes overlap."
        }
      },
      {
        "box": {
          "id": "sel_addbass",
          "maxclass": "newobj",
          "patching_rect": [
            140,
            570,
            55,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "cmd_addbass",
          "maxclass": "message",
          "patching_rect": [
            140,
            600,
            125,
            22
          ],
          "text": "add bass"
        }
      },
      {
        "box": {
          "id": "trigger_addbass",
          "maxclass": "newobj",
          "patching_rect": [
            140,
            640,
            50,
            22
          ],
          "text": "t b b"
        }
      },
      {
        "box": {
          "id": "reset_addbass",
          "maxclass": "message",
          "patching_rect": [
            140,
            670,
            50,
            22
          ],
          "text": "set 0"
        }
      },
      {
        "box": {
          "id": "chordlabel",
          "maxclass": "comment",
          "patching_rect": [
            10,
            73,
            255,
            18
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            73,
            255,
            18
          ],
          "text": "Chord sources (track:scene)",
          "fontsize": 11,
          "textcolor": [
            0.78,
            0.81,
            0.84,
            1
          ],
          "annotation_name": "Chord sources",
          "annotation": "Sources are written as track:scene, using numbers starting at 1. Example: 1:1, 3:1 combines two clips. Edit this field to add or remove sources. Build ABC again after changes."
        }
      },
      {
        "box": {
          "id": "chords",
          "maxclass": "textedit",
          "patching_rect": [
            10,
            90,
            255,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            90,
            255,
            20
          ],
          "varname": "chords",
          "text": "",
          "outputmode": 1,
          "keymode": 0,
          "tabmode": 0,
          "bangmode": 0,
          "fontsize": 11,
          "bgcolor": [
            0.12,
            0.14,
            0.17,
            1
          ],
          "textcolor": [
            0.95,
            0.96,
            0.98,
            1
          ],
          "border": 1,
          "rounded": 4,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "chords",
              "parameter_shortname": "chords",
              "parameter_type": 3,
              "parameter_invisible": 1
            }
          },
          "annotation_name": "Chord sources",
          "annotation": "Sources are written as track:scene, using numbers starting at 1. Example: 1:1, 3:1 combines two clips. Edit this field to add or remove sources. Build ABC again after changes."
        }
      },
      {
        "box": {
          "id": "pre_chords",
          "maxclass": "newobj",
          "patching_rect": [
            10,
            340,
            255,
            22
          ],
          "text": "prepend textfield chords"
        }
      },
      {
        "box": {
          "id": "basslabel",
          "maxclass": "comment",
          "patching_rect": [
            10,
            108,
            255,
            18
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            108,
            255,
            18
          ],
          "text": "Bass sources (track:scene)",
          "fontsize": 11,
          "textcolor": [
            0.78,
            0.81,
            0.84,
            1
          ],
          "annotation_name": "Bass sources",
          "annotation": "Sources are written as track:scene, using numbers starting at 1. Example: 2:1. Edit to add or remove clips. Do not list the same clip as both chord and bass."
        }
      },
      {
        "box": {
          "id": "bass",
          "maxclass": "textedit",
          "patching_rect": [
            10,
            125,
            255,
            18
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            125,
            255,
            18
          ],
          "varname": "bass",
          "text": "",
          "outputmode": 1,
          "keymode": 0,
          "tabmode": 0,
          "bangmode": 0,
          "fontsize": 11,
          "bgcolor": [
            0.12,
            0.14,
            0.17,
            1
          ],
          "textcolor": [
            0.95,
            0.96,
            0.98,
            1
          ],
          "border": 1,
          "rounded": 4,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "bass",
              "parameter_shortname": "bass",
              "parameter_type": 3,
              "parameter_invisible": 1
            }
          },
          "annotation_name": "Bass sources",
          "annotation": "Sources are written as track:scene, using numbers starting at 1. Example: 2:1. Edit to add or remove clips. Do not list the same clip as both chord and bass."
        }
      },
      {
        "box": {
          "id": "pre_bass",
          "maxclass": "newobj",
          "patching_rect": [
            10,
            375,
            255,
            22
          ],
          "text": "prepend textfield bass"
        }
      },
      {
        "box": {
          "id": "barslabel",
          "maxclass": "comment",
          "patching_rect": [
            278,
            4,
            45,
            18
          ],
          "presentation": 1,
          "presentation_rect": [
            278,
            4,
            45,
            18
          ],
          "text": "Bars",
          "fontsize": 11,
          "textcolor": [
            0.78,
            0.81,
            0.84,
            1
          ],
          "annotation_name": "Passage length",
          "annotation": "Number of bars to capture, from 1 to 128. Looping clips repeat from their loop start to fill this length; non-looping clips play once. Uses Live tempo and meter when Build ABC is pressed."
        }
      },
      {
        "box": {
          "id": "bars",
          "maxclass": "textedit",
          "patching_rect": [
            278,
            24,
            45,
            24
          ],
          "presentation": 1,
          "presentation_rect": [
            278,
            24,
            45,
            24
          ],
          "varname": "bars",
          "text": "8",
          "outputmode": 1,
          "keymode": 0,
          "tabmode": 0,
          "bangmode": 0,
          "fontsize": 11,
          "bgcolor": [
            0.12,
            0.14,
            0.17,
            1
          ],
          "textcolor": [
            0.95,
            0.96,
            0.98,
            1
          ],
          "border": 1,
          "rounded": 4,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "bars",
              "parameter_shortname": "bars",
              "parameter_type": 3,
              "parameter_invisible": 1
            }
          },
          "annotation_name": "Passage length",
          "annotation": "Number of bars to capture, from 1 to 128. Looping clips repeat from their loop start to fill this length; non-looping clips play once. Uses Live tempo and meter when Build ABC is pressed."
        }
      },
      {
        "box": {
          "id": "pre_bars",
          "maxclass": "newobj",
          "patching_rect": [
            278,
            274,
            45,
            22
          ],
          "text": "prepend textfield bars"
        }
      },
      {
        "box": {
          "id": "keylabel",
          "maxclass": "comment",
          "patching_rect": [
            330,
            4,
            175,
            18
          ],
          "presentation": 1,
          "presentation_rect": [
            330,
            4,
            175,
            18
          ],
          "text": "Key: auto or D minor",
          "fontsize": 11,
          "textcolor": [
            0.78,
            0.81,
            0.84,
            1
          ],
          "annotation_name": "Musical key",
          "annotation": "Use auto to read Live's current root and scale, or enter a key such as D minor. Source pitches are preserved, including notes outside the scale. Build ABC again after changing this field."
        }
      },
      {
        "box": {
          "id": "key",
          "maxclass": "textedit",
          "patching_rect": [
            330,
            24,
            155,
            24
          ],
          "presentation": 1,
          "presentation_rect": [
            330,
            24,
            155,
            24
          ],
          "varname": "key",
          "text": "auto",
          "outputmode": 1,
          "keymode": 0,
          "tabmode": 0,
          "bangmode": 0,
          "fontsize": 11,
          "bgcolor": [
            0.12,
            0.14,
            0.17,
            1
          ],
          "textcolor": [
            0.95,
            0.96,
            0.98,
            1
          ],
          "border": 1,
          "rounded": 4,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "key",
              "parameter_shortname": "key",
              "parameter_type": 3,
              "parameter_invisible": 1
            }
          },
          "annotation_name": "Musical key",
          "annotation": "Use auto to read Live's current root and scale, or enter a key such as D minor. Source pitches are preserved, including notes outside the scale. Build ABC again after changing this field."
        }
      },
      {
        "box": {
          "id": "pre_key",
          "maxclass": "newobj",
          "patching_rect": [
            330,
            274,
            155,
            22
          ],
          "text": "prepend textfield key"
        }
      },
      {
        "box": {
          "id": "urllabel",
          "maxclass": "comment",
          "patching_rect": [
            278,
            53,
            207,
            18
          ],
          "presentation": 1,
          "presentation_rect": [
            278,
            53,
            207,
            18
          ],
          "text": "ComfyUI address",
          "fontsize": 11,
          "textcolor": [
            0.78,
            0.81,
            0.84,
            1
          ],
          "annotation_name": "ComfyUI address",
          "annotation": "Address of your running ComfyUI server. The default is http://127.0.0.1:8188 for a server on this computer. Use Test connection to check the required YuE2 nodes."
        }
      },
      {
        "box": {
          "id": "url",
          "maxclass": "textedit",
          "patching_rect": [
            278,
            73,
            207,
            24
          ],
          "presentation": 1,
          "presentation_rect": [
            278,
            73,
            207,
            24
          ],
          "varname": "url",
          "text": "http://127.0.0.1:8188",
          "outputmode": 1,
          "keymode": 0,
          "tabmode": 0,
          "bangmode": 0,
          "fontsize": 11,
          "bgcolor": [
            0.12,
            0.14,
            0.17,
            1
          ],
          "textcolor": [
            0.95,
            0.96,
            0.98,
            1
          ],
          "border": 1,
          "rounded": 4,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "url",
              "parameter_shortname": "url",
              "parameter_type": 3,
              "parameter_invisible": 1
            }
          },
          "annotation_name": "ComfyUI address",
          "annotation": "Address of your running ComfyUI server. The default is http://127.0.0.1:8188 for a server on this computer. Use Test connection to check the required YuE2 nodes."
        }
      },
      {
        "box": {
          "id": "pre_url",
          "maxclass": "newobj",
          "patching_rect": [
            278,
            323,
            207,
            22
          ],
          "text": "prepend textfield url"
        }
      },
      {
        "box": {
          "id": "test",
          "maxclass": "textbutton",
          "patching_rect": [
            278,
            105,
            207,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            278,
            105,
            207,
            22
          ],
          "text": "Test connection",
          "texton": "Test connection",
          "mode": 1,
          "fontsize": 11,
          "bgcolor": [
            0.24,
            0.31,
            0.36,
            1
          ],
          "textcolor": [
            1,
            1,
            1,
            1
          ],
          "annotation_name": "Test connection",
          "annotation": "Check that the device can reach ComfyUI and that the required workflow nodes are available. This does not generate audio or load the model."
        }
      },
      {
        "box": {
          "id": "sel_test",
          "maxclass": "newobj",
          "patching_rect": [
            278,
            625,
            55,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "cmd_test",
          "maxclass": "message",
          "patching_rect": [
            278,
            655,
            207,
            22
          ],
          "text": "collect test"
        }
      },
      {
        "box": {
          "id": "trigger_test",
          "maxclass": "newobj",
          "patching_rect": [
            278,
            695,
            50,
            22
          ],
          "text": "t b b"
        }
      },
      {
        "box": {
          "id": "reset_test",
          "maxclass": "message",
          "patching_rect": [
            278,
            725,
            50,
            22
          ],
          "text": "set 0"
        }
      },
      {
        "box": {
          "id": "stylelabel",
          "maxclass": "comment",
          "patching_rect": [
            498,
            4,
            210,
            18
          ],
          "presentation": 1,
          "presentation_rect": [
            498,
            4,
            210,
            18
          ],
          "text": "Sound / style description",
          "fontsize": 11,
          "textcolor": [
            0.78,
            0.81,
            0.84,
            1
          ],
          "annotation_name": "Sound / style description",
          "annotation": "Describe the sound, instruments, genre and performance you want, such as an arpeggiated 1980s synth or breathy vocals. Musical context from the last ABC build is added to the request."
        }
      },
      {
        "box": {
          "id": "rendermode",
          "maxclass": "umenu",
          "patching_rect": [
            498,
            24,
            205,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            498,
            24,
            205,
            22
          ],
          "varname": "rendermode",
          "items": [
            "Vocals only",
            ",",
            "Instrumental only",
            ",",
            "Vocals + instruments"
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Generation mode",
              "parameter_shortname": "Mode",
              "parameter_type": 2,
              "parameter_enum": [
                "Vocals only",
                "Instrumental only",
                "Vocals + instruments"
              ],
              "parameter_initial_enable": 1,
              "parameter_initial": [
                0
              ]
            }
          },
          "annotation_name": "Generation mode",
          "annotation": "Vocals only requests a cappella and sends lyrics. Instrumental only omits lyrics and requests no singing. Vocals + instruments sends lyrics and requests accompaniment. Switching modes updates the generated ABC part labels without changing the notes or chords. Use the description for instruments, vocal character and genre. These are model instructions, not guaranteed stem isolation."
        }
      },
      {
        "box": {
          "id": "mode_message",
          "maxclass": "newobj",
          "patching_rect": [
            820,
            710,
            145,
            22
          ],
          "text": "prepend rendermode"
        }
      },
      {
        "box": {
          "id": "style",
          "maxclass": "textedit",
          "patching_rect": [
            498,
            50,
            205,
            86
          ],
          "presentation": 1,
          "presentation_rect": [
            498,
            50,
            205,
            86
          ],
          "varname": "style",
          "text": "",
          "outputmode": 1,
          "keymode": 0,
          "tabmode": 0,
          "bangmode": 0,
          "fontsize": 11,
          "bgcolor": [
            0.12,
            0.14,
            0.17,
            1
          ],
          "textcolor": [
            0.95,
            0.96,
            0.98,
            1
          ],
          "border": 1,
          "rounded": 4,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "style",
              "parameter_shortname": "style",
              "parameter_type": 3,
              "parameter_invisible": 1
            }
          },
          "annotation_name": "Sound / style description",
          "annotation": "Describe the sound, instruments, genre and performance you want, such as an arpeggiated 1980s synth or breathy vocals. Musical context from the last ABC build is added to the request."
        }
      },
      {
        "box": {
          "id": "pre_style",
          "maxclass": "newobj",
          "patching_rect": [
            498,
            300,
            205,
            22
          ],
          "text": "prepend textfield style"
        }
      },
      {
        "box": {
          "id": "lyricslabel",
          "maxclass": "comment",
          "patching_rect": [
            716,
            4,
            205,
            18
          ],
          "presentation": 1,
          "presentation_rect": [
            716,
            4,
            205,
            18
          ],
          "text": "Lyrics",
          "fontsize": 11,
          "textcolor": [
            0.78,
            0.81,
            0.84,
            1
          ],
          "annotation_name": "Lyrics",
          "annotation": "Lyrics sent to YuE2 in Vocals only and Vocals + instruments modes. They are retained here but omitted from Instrumental requests. You can use section tags such as [verse] and [chorus]."
        }
      },
      {
        "box": {
          "id": "lyrics",
          "maxclass": "textedit",
          "patching_rect": [
            716,
            24,
            205,
            112
          ],
          "presentation": 1,
          "presentation_rect": [
            716,
            24,
            205,
            112
          ],
          "varname": "lyrics",
          "text": "",
          "outputmode": 1,
          "keymode": 0,
          "tabmode": 0,
          "bangmode": 0,
          "fontsize": 11,
          "bgcolor": [
            0.12,
            0.14,
            0.17,
            1
          ],
          "textcolor": [
            0.95,
            0.96,
            0.98,
            1
          ],
          "border": 1,
          "rounded": 4,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "lyrics",
              "parameter_shortname": "lyrics",
              "parameter_type": 3,
              "parameter_invisible": 1
            }
          },
          "annotation_name": "Lyrics",
          "annotation": "Lyrics sent to YuE2 in Vocals only and Vocals + instruments modes. They are retained here but omitted from Instrumental requests. You can use section tags such as [verse] and [chorus]."
        }
      },
      {
        "box": {
          "id": "pre_lyrics",
          "maxclass": "newobj",
          "patching_rect": [
            716,
            274,
            205,
            22
          ],
          "text": "prepend textfield lyrics"
        }
      },
      {
        "box": {
          "id": "abclabel",
          "maxclass": "comment",
          "patching_rect": [
            934,
            4,
            260,
            18
          ],
          "presentation": 1,
          "presentation_rect": [
            934,
            4,
            260,
            18
          ],
          "text": "ABC preview \u2014 editable",
          "fontsize": 11,
          "textcolor": [
            0.78,
            0.81,
            0.84,
            1
          ],
          "annotation_name": "Editable ABC score",
          "annotation": "Score built from the configured source clips. Review chord names and edit if needed. Generate uses this text; Build ABC replaces it and any manual edits."
        }
      },
      {
        "box": {
          "id": "abc",
          "maxclass": "textedit",
          "patching_rect": [
            934,
            24,
            310,
            78
          ],
          "presentation": 1,
          "presentation_rect": [
            934,
            24,
            310,
            78
          ],
          "varname": "abc",
          "text": "",
          "outputmode": 1,
          "keymode": 0,
          "tabmode": 0,
          "bangmode": 0,
          "fontsize": 11,
          "bgcolor": [
            0.12,
            0.14,
            0.17,
            1
          ],
          "textcolor": [
            0.95,
            0.96,
            0.98,
            1
          ],
          "border": 1,
          "rounded": 4,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "abc",
              "parameter_shortname": "abc",
              "parameter_type": 3,
              "parameter_invisible": 1
            }
          },
          "annotation_name": "Editable ABC score",
          "annotation": "Score built from the configured source clips. Review chord names and edit if needed. Generate uses this text; Build ABC replaces it and any manual edits."
        }
      },
      {
        "box": {
          "id": "pre_abc",
          "maxclass": "newobj",
          "patching_rect": [
            934,
            274,
            310,
            22
          ],
          "text": "prepend textfield abc"
        }
      },
      {
        "box": {
          "id": "build",
          "maxclass": "textbutton",
          "patching_rect": [
            934,
            110,
            147,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            934,
            110,
            147,
            22
          ],
          "text": "1  Build ABC",
          "texton": "1  Build ABC",
          "mode": 1,
          "fontsize": 11,
          "bgcolor": [
            0.24,
            0.31,
            0.36,
            1
          ],
          "textcolor": [
            1,
            1,
            1,
            1
          ],
          "annotation_name": "Build ABC",
          "annotation": "Read the source MIDI clips and Live tempo, meter and scale, then create an ABC score for the requested bars. Rebuild after changing sources, MIDI, key, tempo or length. This replaces manual ABC edits and does not generate audio."
        }
      },
      {
        "box": {
          "id": "sel_build",
          "maxclass": "newobj",
          "patching_rect": [
            934,
            630,
            55,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "cmd_build",
          "maxclass": "message",
          "patching_rect": [
            934,
            660,
            147,
            22
          ],
          "text": "collect build"
        }
      },
      {
        "box": {
          "id": "trigger_build",
          "maxclass": "newobj",
          "patching_rect": [
            934,
            700,
            50,
            22
          ],
          "text": "t b b"
        }
      },
      {
        "box": {
          "id": "reset_build",
          "maxclass": "message",
          "patching_rect": [
            934,
            730,
            50,
            22
          ],
          "text": "set 0"
        }
      },
      {
        "box": {
          "id": "generate",
          "maxclass": "textbutton",
          "patching_rect": [
            1090,
            110,
            154,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            1090,
            110,
            154,
            22
          ],
          "text": "2  Generate",
          "texton": "2  Generate",
          "mode": 1,
          "fontsize": 11,
          "bgcolor": [
            0.24,
            0.31,
            0.36,
            1
          ],
          "textcolor": [
            1,
            1,
            1,
            1
          ],
          "annotation_name": "Generate a new take",
          "annotation": "Send the current style, mode, lyrics and ABC to ComfyUI. Uses duration and musical context from the last ABC build. Saves the finished audio in renders and, if selected, imports it into the destination audio track."
        }
      },
      {
        "box": {
          "id": "sel_generate",
          "maxclass": "newobj",
          "patching_rect": [
            1090,
            630,
            55,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "cmd_generate",
          "maxclass": "message",
          "patching_rect": [
            1090,
            660,
            154,
            22
          ],
          "text": "collect generate"
        }
      },
      {
        "box": {
          "id": "trigger_generate",
          "maxclass": "newobj",
          "patching_rect": [
            1090,
            700,
            50,
            22
          ],
          "text": "t b b"
        }
      },
      {
        "box": {
          "id": "reset_generate",
          "maxclass": "message",
          "patching_rect": [
            1090,
            730,
            50,
            22
          ],
          "text": "set 0"
        }
      },
      {
        "box": {
          "id": "destlabel",
          "maxclass": "comment",
          "patching_rect": [
            1258,
            4,
            245,
            18
          ],
          "presentation": 1,
          "presentation_rect": [
            1258,
            4,
            245,
            18
          ],
          "text": "Send audio to track",
          "fontsize": 11,
          "textcolor": [
            0.78,
            0.81,
            0.84,
            1
          ],
          "annotation_name": "Destination audio track",
          "annotation": "Choose an audio track for automatic import into its first empty Session slot, or Save only. The destination is captured when Generate is pressed. Existing clips are never replaced and playback is not started."
        }
      },
      {
        "box": {
          "id": "destmenu",
          "maxclass": "umenu",
          "patching_rect": [
            1258,
            24,
            245,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            1258,
            24,
            245,
            22
          ],
          "varname": "destmenu",
          "items": [
            "Save only (no import)"
          ],
          "parameter_enable": 0,
          "annotation_name": "Destination audio track",
          "annotation": "Choose an audio track for automatic import into its first empty Session slot, or Save only. The destination is captured when Generate is pressed. Existing clips are never replaced and playback is not started."
        }
      },
      {
        "box": {
          "id": "destmessage",
          "maxclass": "newobj",
          "patching_rect": [
            900,
            710,
            145,
            22
          ],
          "text": "prepend destination"
        }
      },
      {
        "box": {
          "id": "importlatest",
          "maxclass": "textbutton",
          "patching_rect": [
            1258,
            52,
            245,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            1258,
            52,
            245,
            22
          ],
          "text": "Import latest take",
          "texton": "Import latest take",
          "mode": 1,
          "fontsize": 11,
          "bgcolor": [
            0.24,
            0.31,
            0.36,
            1
          ],
          "textcolor": [
            1,
            1,
            1,
            1
          ],
          "annotation_name": "Import latest take",
          "annotation": "Import the most recent render completed by this device instance into the currently selected audio track's first empty Session slot. No new generation or playback is started. Useful for copying a take to another track or retrying an import. Each click creates another clip; the saved file remains in renders. Not available after reloading the device until another take completes."
        }
      },
      {
        "box": {
          "id": "sel_importlatest",
          "maxclass": "newobj",
          "patching_rect": [
            1258,
            572,
            55,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "cmd_importlatest",
          "maxclass": "message",
          "patching_rect": [
            1258,
            602,
            245,
            22
          ],
          "text": "importlatest"
        }
      },
      {
        "box": {
          "id": "trigger_importlatest",
          "maxclass": "newobj",
          "patching_rect": [
            1258,
            642,
            50,
            22
          ],
          "text": "t b b"
        }
      },
      {
        "box": {
          "id": "reset_importlatest",
          "maxclass": "message",
          "patching_rect": [
            1258,
            672,
            50,
            22
          ],
          "text": "set 0"
        }
      },
      {
        "box": {
          "id": "stage",
          "maxclass": "comment",
          "patching_rect": [
            1258,
            83,
            245,
            30
          ],
          "presentation": 1,
          "presentation_rect": [
            1258,
            83,
            245,
            30
          ],
          "varname": "stage",
          "text": "Ready",
          "fontsize": 11,
          "textcolor": [
            0.78,
            0.81,
            0.84,
            1
          ],
          "annotation_name": "Current generation stage",
          "annotation": "Current ComfyUI stage, such as music generation, audio sampling, decoding or saving. Some stages do not publish numerical progress."
        }
      },
      {
        "box": {
          "id": "progress",
          "maxclass": "slider",
          "patching_rect": [
            1258,
            117,
            245,
            15
          ],
          "presentation": 1,
          "presentation_rect": [
            1258,
            117,
            245,
            15
          ],
          "varname": "progress",
          "size": 100.0,
          "floatoutput": 1,
          "orientation": 1,
          "ignoreclick": 1,
          "bgcolor": [
            0.16,
            0.19,
            0.22,
            1
          ],
          "knobcolor": [
            0.35,
            0.8,
            0.65,
            1
          ],
          "annotation_name": "Current stage progress",
          "annotation": "Live progress for this device's ComfyUI request. Percentage applies to the current stage and can reset between stages or internal passes. It is not an overall completion percentage or time estimate."
        }
      },
      {
        "box": {
          "id": "status",
          "maxclass": "comment",
          "patching_rect": [
            10,
            146,
            1495,
            21
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            146,
            1495,
            21
          ],
          "varname": "status",
          "text": "Starting bridge...",
          "fontsize": 11,
          "textcolor": [
            0.63,
            0.86,
            0.75,
            1
          ],
          "annotation_name": "Device status",
          "annotation": "Connection results, capture details, chord warnings, import results and errors appear here. If audio import fails, the rendered file is still kept in renders."
        }
      },
      {
        "box": {
          "id": "controller",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            750,
            180,
            22
          ],
          "text": "js live.js",
          "varname": "controller"
        }
      },
      {
        "box": {
          "id": "defer",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            710,
            80,
            22
          ],
          "text": "deferlow"
        }
      },
      {
        "box": {
          "id": "node",
          "maxclass": "newobj",
          "patching_rect": [
            300,
            750,
            280,
            22
          ],
          "text": "node.script max-entry.js @autostart 1 @watch 0"
        }
      },
      {
        "box": {
          "id": "noderesponse",
          "maxclass": "newobj",
          "patching_rect": [
            300,
            790,
            80,
            22
          ],
          "text": "deferlow"
        }
      },
      {
        "box": {
          "id": "print",
          "maxclass": "newobj",
          "patching_rect": [
            590,
            790,
            160,
            22
          ],
          "text": "print YuE2-Bridge"
        }
      },
      {
        "box": {
          "id": "device",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            650,
            95,
            22
          ],
          "text": "live.thisdevice"
        }
      },
      {
        "box": {
          "id": "init",
          "maxclass": "message",
          "patching_rect": [
            150,
            650,
            40,
            22
          ],
          "text": "init"
        }
      },
      {
        "box": {
          "id": "midiin",
          "maxclass": "newobj",
          "patching_rect": [
            650,
            650,
            55,
            22
          ],
          "text": "midiin"
        }
      },
      {
        "box": {
          "id": "midiout",
          "maxclass": "newobj",
          "patching_rect": [
            650,
            700,
            55,
            22
          ],
          "text": "midiout"
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "refresh",
            0
          ],
          "destination": [
            "sel_refresh",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sel_refresh",
            0
          ],
          "destination": [
            "trigger_refresh",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_refresh",
            1
          ],
          "destination": [
            "reset_refresh",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reset_refresh",
            0
          ],
          "destination": [
            "refresh",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_refresh",
            0
          ],
          "destination": [
            "cmd_refresh",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cmd_refresh",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "clipmenu",
            0
          ],
          "destination": [
            "pickmessage",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pickmessage",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "addchord",
            0
          ],
          "destination": [
            "sel_addchord",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sel_addchord",
            0
          ],
          "destination": [
            "trigger_addchord",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_addchord",
            1
          ],
          "destination": [
            "reset_addchord",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reset_addchord",
            0
          ],
          "destination": [
            "addchord",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_addchord",
            0
          ],
          "destination": [
            "cmd_addchord",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cmd_addchord",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "addbass",
            0
          ],
          "destination": [
            "sel_addbass",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sel_addbass",
            0
          ],
          "destination": [
            "trigger_addbass",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_addbass",
            1
          ],
          "destination": [
            "reset_addbass",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reset_addbass",
            0
          ],
          "destination": [
            "addbass",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_addbass",
            0
          ],
          "destination": [
            "cmd_addbass",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cmd_addbass",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "chords",
            0
          ],
          "destination": [
            "pre_chords",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pre_chords",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bass",
            0
          ],
          "destination": [
            "pre_bass",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pre_bass",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bars",
            0
          ],
          "destination": [
            "pre_bars",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pre_bars",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "key",
            0
          ],
          "destination": [
            "pre_key",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pre_key",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "url",
            0
          ],
          "destination": [
            "pre_url",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pre_url",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "test",
            0
          ],
          "destination": [
            "sel_test",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sel_test",
            0
          ],
          "destination": [
            "trigger_test",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_test",
            1
          ],
          "destination": [
            "reset_test",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reset_test",
            0
          ],
          "destination": [
            "test",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_test",
            0
          ],
          "destination": [
            "cmd_test",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cmd_test",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rendermode",
            0
          ],
          "destination": [
            "mode_message",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "mode_message",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "style",
            0
          ],
          "destination": [
            "pre_style",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pre_style",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lyrics",
            0
          ],
          "destination": [
            "pre_lyrics",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pre_lyrics",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "abc",
            0
          ],
          "destination": [
            "pre_abc",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pre_abc",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "build",
            0
          ],
          "destination": [
            "sel_build",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sel_build",
            0
          ],
          "destination": [
            "trigger_build",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_build",
            1
          ],
          "destination": [
            "reset_build",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reset_build",
            0
          ],
          "destination": [
            "build",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_build",
            0
          ],
          "destination": [
            "cmd_build",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cmd_build",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "generate",
            0
          ],
          "destination": [
            "sel_generate",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sel_generate",
            0
          ],
          "destination": [
            "trigger_generate",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_generate",
            1
          ],
          "destination": [
            "reset_generate",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reset_generate",
            0
          ],
          "destination": [
            "generate",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_generate",
            0
          ],
          "destination": [
            "cmd_generate",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cmd_generate",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "destmenu",
            0
          ],
          "destination": [
            "destmessage",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "destmessage",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "importlatest",
            0
          ],
          "destination": [
            "sel_importlatest",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sel_importlatest",
            0
          ],
          "destination": [
            "trigger_importlatest",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_importlatest",
            1
          ],
          "destination": [
            "reset_importlatest",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reset_importlatest",
            0
          ],
          "destination": [
            "importlatest",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "trigger_importlatest",
            0
          ],
          "destination": [
            "cmd_importlatest",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cmd_importlatest",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "defer",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "controller",
            0
          ],
          "destination": [
            "node",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "node",
            0
          ],
          "destination": [
            "noderesponse",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "noderesponse",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "node",
            1
          ],
          "destination": [
            "print",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "device",
            0
          ],
          "destination": [
            "init",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "init",
            0
          ],
          "destination": [
            "defer",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "midiin",
            0
          ],
          "destination": [
            "midiout",
            0
          ]
        }
      }
    ],
    "autosave": 0,
    "dependency_cache": [
      {
        "name": "live.js",
        "patcherrelativepath": ".",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "max-entry.js",
        "patcherrelativepath": ".",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "bridge.js",
        "patcherrelativepath": ".",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "progress.js",
        "patcherrelativepath": ".",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "core.js",
        "patcherrelativepath": ".",
        "type": "TEXT",
        "implicit": 1
      }
    ]
  }
}